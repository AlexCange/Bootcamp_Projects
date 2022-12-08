
import streamlit as st
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from PIL import Image

movies_df = pd.read_csv('Dataframes/movies.csv')
ratings_df = pd.read_csv('Dataframe/ratings.csv')

# CREATE A DF WITH TITLES AND RATINGS:

ratings_movies = ratings_df.groupby('movieId')[['movieId', 'rating', 'userId']].agg({"userId":"count", "rating":"mean"})
ratings_movies = ratings_movies.reset_index()
ratings_movies = ratings_movies.merge(movies_df, left_on='movieId', right_on='movieId')
ratings_movies.genres = ratings_movies.genres.str.replace('|',',')
ratings_movies = ratings_movies[['movieId', 'title', 'userId', 'rating', 'genres']]
ratings_movies = ratings_movies.rename(columns={
    'userId':'Total Reviews',
    'title':'Title',
    'rating':'Rating',
    'genres':'Genre'
})
ratings_movies.loc[ratings_movies['Title'].str.contains("(\d{4})"), 'Released Year'] = ratings_movies.Title.str[-6:]
ratings_movies.loc[ratings_movies['Title'].str.contains("(\d{4})"), 'Title'] = ratings_movies.Title.str[:-6]
ratings_movies['Released Year'] = ratings_movies['Released Year'].str.replace('\D', '')
ratings_movies['Released Year'] = ratings_movies['Released Year'].fillna('Unknown')
ratings_movies.loc[ratings_movies['Title'].str.contains("(\d{4})"), 'Title'] = ratings_movies.Title.str[:-6]
ratings_movies = ratings_movies.set_index('Title')


users_items = pd.pivot_table(data=ratings_df, 
                                 values='rating', 
                                 index='userId', 
                                 columns='movieId')

users_items.fillna(0, inplace=True)

user_similarities = pd.DataFrame(cosine_similarity(users_items),
                                 columns=users_items.index, 
                                 index=users_items.index)

# FUNCTION TO GET THE LIST OF MOVIES WITH GENRES
def genre_selection(input_genre,n):
    for i in ratings_movies.Genre:
        if i == input_genre:
            top_genre = ratings_movies.loc[ratings_movies.Genre.str.contains(i),['Rating', 'Total Reviews']].nlargest(n,'Total Reviews').sort_values('Rating', ascending=False)
    return top_genre

def genre_selection2(input_genre):
    for i in ratings_movies.Genre:
        if i == input_genre:
            top_genre = ratings_movies.loc[ratings_movies.Genre.str.contains(i),['Rating', 'Total Reviews']].sort_values('Total Reviews', ascending=False)
    return top_genre

Genre_all = ratings_movies.Genre
Genre_all = list(Genre_all.str.split(','))
list_genre= ['',]
for i in Genre_all:
    for j in i:
        list_genre.append(j)
    
genre_df = pd.DataFrame(list_genre).drop_duplicates()
Genres = list(genre_df[0])

# FUNCTION TO GET POPULAR MOVIES
def popular_movies(n):
    ratings_movies_top_20_popular = ratings_movies.nlargest(38, 'Total Reviews').sort_values(by='Rating', ascending=False)
    return ratings_movies_top_20_popular[[ 'Total Reviews', 'Rating', 'Released Year']].head(n)

# FUNCTION TO GET "WHAT DO YOU MEAN"
def do_you_mean(xxx):
    xxx = xxx.title()
    titles = list(movies_df.loc[movies_df.title.str.contains(xxx),'title'])
    return titles

# FUNCTION TO GET ITEM BASED RECOMMENDATIONS

user_item_df = pd.pivot_table(data=ratings_df, values='rating', index='userId', columns='movieId')

def similar_movies(xxx, n):

    movie_id = int(movies_df.loc[movies_df.title.str.contains(xxx),'movieId'].head(1))
    movie_ratings = user_item_df.loc[:,movie_id]
    similar_to_movie = user_item_df.corrwith(movie_ratings)

    corr_movie_id = pd.DataFrame(similar_to_movie, columns=['PearsonR'])
    corr_movie_id.dropna(inplace=True)

    rating = pd.DataFrame(ratings_df.groupby('movieId')['rating'].mean())
    rating['rating_count'] = ratings_df.groupby('movieId')['rating'].count()

    movie_corr_summary = corr_movie_id.join(rating[['rating_count','rating']])
    movie_corr_summary.drop(movie_id, inplace=True)

    topn = movie_corr_summary[movie_corr_summary['rating_count']>=movie_corr_summary['rating_count'].mean()].sort_values('PearsonR', ascending=False).head(n)

    movies_name =  movies_df[['movieId', 'title']]
    topn = topn.merge(movies_name, left_index=True, right_on="movieId")
    topn = topn.rename(columns={'title':'Title', 'rating_count':'Total Reviews', 'rating':'Rating Score'})
    topn = topn[['Title', 'Total Reviews', 'Rating Score']].set_index('Title')
    return topn.sort_values('Rating Score', ascending=False)

# FUNCTION TO GET USER BASED RECOMMENDATIONS
def recom_rest(user_id, n):
    user_id = int(user_id)
    weights = (
        user_similarities.query("userId!=@user_id")[user_id] / sum(user_similarities.query("userId!=@user_id")[user_id])
            )
    not_watched_movies = users_items.loc[users_items.index!=user_id, users_items.loc[user_id,:]==0]

    weighted_averages = pd.DataFrame(not_watched_movies.T.dot(weights), columns=["predicted_rating"])

    recommendations = weighted_averages.merge(movies_df, left_index=True, right_on="movieId")
    recommendations = recommendations.sort_values("predicted_rating", ascending=False).head(n)
    return recommendations.title


## STREAMLIT APP INPUTS ==>
st.title('Welcome at WBSFLIX!')

#image = Image.open('Bootcamp_Projects/RecommenderSytems/movie_night.jpeg')
#st.image(image)


st.header('Most Popular Movies')
st.subheader('How many movies do you want us to recommend you?')
pickednumber = st.slider('', min_value=1, max_value=100, value=10, step=None, format=None, key='n', help=None, on_change=None, args=None, kwargs=None, disabled=False, label_visibility="visible")


df_pop = st.dataframe(popular_movies(pickednumber), use_container_width=True )
st.header('Which movie are you in today?')
movie_recom_select = st.selectbox('Our list of movies:',options=list(ratings_movies.index))

st.header('You might also like... ')
st.table(similar_movies(movie_recom_select,5))


st.header('Only for you:')
user_id_input = st.number_input('Enter your user ID',value=0)
n_recom = st.slider('How many Movie would you like us to recommend you? ', min_value=5, max_value=20, value=5)
if user_id_input == 0:
    st.warning('Please enter your ID')
else:
    st.dataframe(recom_rest(user_id_input, n_recom),use_container_width=True )

st.header('Wish a special kind of movie?')
input_genre = st.selectbox('What kind of movie do you want?', options=Genres)
if input_genre == '':
    st.write('Pick a genre!')
else:
    st.write('The most popular ' + input_genre + ' movies')
    st.table(genre_selection(input_genre,10))
    if st.button('Load More'):
        st.dataframe(genre_selection2(input_genre), use_container_width=True)


