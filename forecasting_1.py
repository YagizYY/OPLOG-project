import pandas as pd
import pyreadr
import numpy as np
import math

file = "Forecast/for_ma.rds"
Zone = "Zone_1"

def MA(file, Zone):
    sales = pyreadr.read_r(file)
    sales = sales[None]
    sales = sales[sales['WeekOrder'].isin(np.arange(1, 102))]
    sales.drop(['Year', 'Week', 'Date'], axis=1, inplace=True)
    sales['WeekOrder'].nunique()

    Pred = pd.DataFrame.from_dict({'Zone': [],
                                   'ProductId': [],
                                   'Prediction': []})

    #Zones = ['Zone_1', 'Zone_2', 'Zone_3', 'Zone_4', 'Zone_5']
    Pred = pd.DataFrame.from_dict({'Zone': [],
                                   'ProductId': [],
                                   'Prediction': []})

    sales = sales[["Zone", "ProductId", "WeekOrder", "Sales"]]
    sales = sales.sort_values(by=["Zone", "ProductId", "WeekOrder"])

    values1 = [97, 98, 99, 100, 101]
    values2 = [97, 98, 99, 100]
    values3 = [101]
    train = sales[sales["WeekOrder"].isin(values1) == False]
    train = train.reset_index(drop=True)

    test = sales[sales.WeekOrder.isin(values3)]
    test = test.reset_index(drop=True)

    train2 = sales[sales.WeekOrder.isin(values3) == False]
    train2 = train2.reset_index(drop=True)

    # only has the first 100 weeks of data
    sales1_train = train[train["Zone"] == Zone]
    sales1_train = sales1_train.sort_values(by=["ProductId", "WeekOrder"])
    sales1_train = sales1_train.reset_index(drop=True)

    # has 104 weeks of data
    sales1_train2 = train2[train2["Zone"] == Zone]
    sales1_train2 = sales1_train2.sort_values(by=["ProductId", "WeekOrder"])
    sales1_train2 = sales1_train2.reset_index(drop=True)

    # only has the last week of data
    sales1_test = test[test["Zone"] == Zone]
    sales1_test = sales1_test.sort_values(by=["ProductId", "WeekOrder"])
    sales1_test = sales1_test.reset_index(drop=True)
    sales1_test['Prediction'] = np.nan

    for i in range(0, len(sales1_test.axes[0])):
        demand = sales1_train2[100 * i:100 * (i + 1)][["WeekOrder", "Sales"]]
        new_rows = [{'WeekOrder': 101, 'Sales': 0}]
        demand = demand.append(new_rows, ignore_index=True)
        demand.set_index('WeekOrder', inplace=True)
        sma = demand.rolling(window=4).mean()
        demand["Sales"][100] = math.ceil(sma["Sales"][100])
        demand = demand.reset_index()
        fcast = sma["Sales"][101]
        sales1_test.at[i, 'Prediction'] = math.ceil(fcast)
    Pred = pd.concat([Pred, sales1_test])
    Pred.drop(columns='Sales', inplace=True)
    return Pred


MA(file,Zone)

