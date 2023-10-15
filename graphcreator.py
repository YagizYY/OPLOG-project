##%%
#import os

#%%
import pyreadr
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

#%%
result1 = pyreadr.read_r("Graph/direct_assignment.rds")
result1 = result1[None]
result1 = result1[["Zone", "ProductId"]]
result1["Count"] = "Less Than 20"
result1["SFR"] = "Less than 0.65"

result3 = pyreadr.read_r("Graph/for_ma.rds")
result3 = result3[None]
result3 = result3[["Zone", "ProductId"]]
result3["Count"] = "Less Than 20"
result3["SFR"] = "More than 0.65"

result2 = pyreadr.read_r("Graph/for_croston.rds")
result2 = result2[None]
result2 = result2[["Zone", "ProductId"]]
result2["Count"] = "More Than 20"
result2["SFR"] = "Less than 0.65"

result4 = pyreadr.read_r("Graph/for_ML.rds")
result4 = result4[None]
result4 = result4[["Zone", "ProductId"]]
result4["Count"] = "More Than 20"
result4["SFR"] = "More than 0.65"


result = pd.concat([result1, result2, result3, result4])

grouped = result.groupby('Zone')['ProductId'].nunique()

#%%
# create a bar plot
def number_unique():
    colors=['tab:purple']
    grouped.plot(kind='bar', color=colors)
    plt.title('Number of Unique Products per Zone')
    plt.xlabel('Zone')
    plt.ylabel('Number of Unique Products')
    return plt.show()


#%%
def number_sales():
    for_bar1 = result.groupby(['Zone', 'Count'])['ProductId'].nunique().reset_index(name='UniqueProductCount')

    #%%
    fig, ax = plt.subplots()
    colors = ['tab:orange', 'tab:green']
    for_bar1.groupby(['Zone', 'Count'])['UniqueProductCount'].sum().unstack().plot(kind='bar', stacked=True, ax=ax, color=colors)
    ax.set_xlabel('Zones')
    ax.set_ylabel('Count')
    ax.set_title('Number of Weeks Subject To Sales Product Counts per Zone')
    return plt.show()

#%%

def number_SFR():
    for_bar2 = result.groupby(['Zone', 'SFR'])['ProductId'].nunique().reset_index(name='UniqueProductCount')

    #%%
    fig, ax = plt.subplots()
    colors = ['tab:orange', 'tab:green']
    for_bar2.groupby(['Zone', 'SFR'])['UniqueProductCount'].sum().unstack().plot(kind='bar', stacked=True, ax=ax, color=colors)
    ax.set_xlabel('Zones')
    ax.set_ylabel('Sales Frequency Ratio')
    ax.set_title('Sales Frequency Ratio Product Counts per Zone')
    return plt.show()