import pickle
import numpy as np
import pandas as pd
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.preprocessing import MaxAbsScaler,FunctionTransformer, Imputer
from sklearn.feature_selection import SelectKBest, f_regression

 # First we build two utility functions to parse numeric and text data, and wrap them using FunctionTransformer, so that they can be integrated into a sklearn pipeline:
def text_columns(X_train):
    return X_train.TEXT_FEATURES
   
def numeric_columns(X_train):
    numeric = ["DEVICENAME_PRIOR_CLEARANCE_TO_DATE","APPLICANT_PRIOR_CLEARANCE_TO_DATE"]
    temp = X_train[numeric]
    return temp
       
get_numeric_data = FunctionTransformer(func = numeric_columns, validate=False) 
get_text_data = FunctionTransformer(func = text_columns,validate=False) 
    # Note how we avoid putting any arguments into text_columns and numeric_columns
    
    # We also need to create our regex token pattern to use in HashingVectorizer. 
TOKENS_ALPHANUMERIC = '[A-Za-z0-9]+(?=\\s+)'   
    #Note this regex will match either a whitespace or a punctuation to tokenize the string vector on these preferences  
    
    # We also need to redefine the default feature selection function for regression to properly place into our pipeline:
def f_regression(X,Y):
    import sklearn
    return sklearn.feature_selection.f_regression(X,Y,center = False) # default is center = True

def make_prediction(my_df):
   df = my_df 
   with open("./functions/pipeline510k_tree3.pkl","rb") as f:
        pipeline510k_tree3 = pickle.load(f)
   print("Loaded Pipeline")    
    
   X_val = pipeline510k_tree3.transform(df)
   
   with open("./functions/lgbm1_model.pkl","rb") as f:
        lgbm1_model = pickle.load(f)
   print("Loaded Model Object")
   
   preds = np.exp(lgbm1_model.predict(X_val))
   
   return preds        
