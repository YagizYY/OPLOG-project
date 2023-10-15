import pyreadr
import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt
import datetime
import math
from sklearn.metrics import mean_absolute_error as mae
from croston import croston
from statsforecast.models import TSB
from statsforecast.models import IMAPA
from statsforecast.models import ADIDA
from statsforecast.models import CrostonOptimized
from statsforecast.models import CrostonSBA


file = 'Forecast/for_croston.rds'
Zone = "Zone_1"

pd.set_option('display.max_columns', None)

def intermittent(file, Zone):
    sales = pyreadr.read_r(file)
    sales = sales[None]
    sales = sales[sales['WeekOrder'].isin(np.arange(1, 102))]
    sales['WeekOrder'].nunique()

    sales = sales[["Zone", "ProductId", "WeekOrder", "Sales"]]
    sales = sales.sort_values(by=["Zone", "ProductId", "WeekOrder"])

    Horizon = 96

    values1 = [97, 98, 99, 100, 101]
    values2 = [97, 98, 99, 100]
    values3 = [101]
    train = sales[sales["WeekOrder"].isin(values1) == False]
    train = train.reset_index(drop=True)

    val = sales[sales["WeekOrder"].isin(values2)]
    val = val.reset_index(drop=True)

    test = sales[sales.WeekOrder.isin(values3)]
    test = test.reset_index(drop=True)

    train2 = sales[sales.WeekOrder.isin(values3) == False]
    train2 = train2.reset_index(drop=True)

    # Zones = ['Zone_1', 'Zone_2', 'Zone_3', 'Zone_4', 'Zone_5']
    Pred = pd.DataFrame.from_dict({'Zone': [],
                                   'ProductId': [],
                                   'Prediction': []})

    Error = pd.DataFrame.from_dict({'Zone': [],
                                    'ProductId': [],
                                    'MAE (Croston)': [],
                                    'MAE (Moving Average)': [],
                                    'MAE (TSB)': [],
                                    'MAE (IMAPA)': [],
                                    'MAE (ADIDA)': [],
                                    'MAE (Croston Optimized)': [],
                                    'MAE (Croston SBA)': [],
                                    'Winner': []})

    # only has the first 100 weeks of data
    sales1_train = train[train["Zone"] == Zone]
    sales1_train = sales1_train.sort_values(by=["ProductId", "WeekOrder"])
    sales1_train = sales1_train.reset_index(drop=True)

    # only has the last 4 weeks of data
    sales1_val = val[val["Zone"] == Zone]
    sales1_val = sales1_val.sort_values(by=["ProductId", "WeekOrder"])
    sales1_val = sales1_val.reset_index(drop=True)
    sales1_val['Prediction (Croston)'] = np.nan
    sales1_val['Prediction (Moving Average)'] = np.nan
    sales1_val['Prediction (TSB)'] = np.nan
    sales1_val['Prediction (IMAPA)'] = np.nan
    sales1_val['Prediction (ADIDA)'] = np.nan
    sales1_val['Prediction (Croston Optimized)'] = np.nan
    sales1_val['Prediction (Croston SBA)'] = np.nan

    # has 104 weeks of data
    sales1_train2 = train2[train2["Zone"] == Zone]
    sales1_train2 = sales1_train2.sort_values(by=["ProductId", "WeekOrder"])
    sales1_train2 = sales1_train2.reset_index(drop=True)

    # only has the last week of data
    sales1_test = test[test["Zone"] == Zone]
    sales1_test = sales1_test.sort_values(by=["ProductId", "WeekOrder"])
    sales1_test = sales1_test.reset_index(drop=True)
    sales1_test['Prediction'] = np.nan

    sales1_train_x = sales1_train['WeekOrder']
    sales1_train_y = sales1_train['Sales']

    sales1_val_x = sales1_val['WeekOrder']
    sales1_val_y = sales1_val['Sales']

    sales1_test_x = sales1_test['WeekOrder']
    sales1_test_y = sales1_test['Sales']

    sales1_train_x2 = sales1_train2['WeekOrder']
    sales1_train_y2 = sales1_train2['Sales']

    error_sales1 = sales1_test.copy()
    error_sales1 = error_sales1[['Zone', 'ProductId']]
    error_sales1['MAE (Croston)'] = np.nan
    error_sales1['MAE (Moving Average)'] = np.nan
    error_sales1['MAE (TSB)'] = np.nan
    error_sales1['MAE (IMAPA)'] = np.nan
    error_sales1['MAE (ADIDA)'] = np.nan
    error_sales1['MAE (Croston Optimized)'] = np.nan
    error_sales1['MAE (Croston SBA)'] = np.nan

    for i in range(0, sales1_test.shape[0]):
        demand = sales1_train_y[Horizon * i:Horizon * (i + 1)].to_list()
        if sum(demand) == 0:
            sales1_val.at[4 * i, 'Prediction (Croston)'] = 0
            sales1_val.at[4 * i + 1, 'Prediction (Croston)'] = 0
            sales1_val.at[4 * i + 2, 'Prediction (Croston)'] = 0
            sales1_val.at[4 * i + 3, 'Prediction (Croston)'] = 0
        else:
            demand_df = pd.Series(demand)
            fit3 = croston.fit_croston(demand_df, 4, 'original')
            fcast = fit3['croston_forecast']
            sales1_val.at[4 * i, 'Prediction (Croston)'] = fcast[0]
            sales1_val.at[4 * i + 1, 'Prediction (Croston)'] = fcast[1]
            sales1_val.at[4 * i + 2, 'Prediction (Croston)'] = fcast[2]
            sales1_val.at[4 * i + 3, 'Prediction (Croston)'] = fcast[3]

    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 3, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 3, ["Prediction (Croston)"]].values
        error_sales1.at[t, 'MAE (Croston)'] = mae(actual, forecast)
        error_sales1
        sales1_val

    for i in range(0, sales1_test.shape[0]):
        demand = sales1_train[Horizon * i:Horizon * (i + 1)][["WeekOrder", "Sales"]]
        for j in range(0, 4):
            new_rows = [{'WeekOrder': Horizon + 1 + j, 'Sales': 0}]
            demand = demand.append(new_rows, ignore_index=True)
            demand.set_index('WeekOrder', inplace=True)
            sma = demand.rolling(window=4).mean()
            demand["Sales"][Horizon + 1 + j] = sma["Sales"][Horizon + 1 + j]
            demand = demand.reset_index()
        fcast = sma["Sales"][Horizon:(Horizon + 5)].to_list()
        sales1_val.at[4 * i, 'Prediction (Moving Average)'] = fcast[0]
        sales1_val.at[4 * i + 1, 'Prediction (Moving Average)'] = fcast[1]
        sales1_val.at[4 * i + 2, 'Prediction (Moving Average)'] = fcast[2]
        sales1_val.at[4 * i + 3, 'Prediction (Moving Average)'] = fcast[3]
    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 3, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 3, ["Prediction (Moving Average)"]].values
        error_sales1.at[t, 'MAE (Moving Average)'] = mae(actual, forecast)

    model = TSB(alpha_d=0.5, alpha_p=0.5)
    for i in range(0, len(sales1_test.axes[0])):
        demand = sales1_train_y[Horizon * i:Horizon * (i + 1)].values
        fit3 = model.fit(demand)
        fcast = model.predict(h=4)
        sales1_val.at[4 * i, 'Prediction (TSB)'] = fcast['mean'][0]
        sales1_val.at[4 * i + 1, 'Prediction (TSB)'] = fcast['mean'][1]
        sales1_val.at[4 * i + 2, 'Prediction (TSB)'] = fcast['mean'][2]
        sales1_val.at[4 * i + 3, 'Prediction (TSB)'] = fcast['mean'][3]
    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 4, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 4, ["Prediction (TSB)"]].values
        error_sales1.at[t, 'MAE (TSB)'] = mae(actual, forecast)

    model = IMAPA()
    for i in range(0, len(sales1_test.axes[0])):
        demand = sales1_train_y[Horizon * i:Horizon * (i + 1)].values
        fit3 = model.fit(demand)
        fcast = model.predict(h=4)
        sales1_val.at[4 * i, 'Prediction (IMAPA)'] = fcast['mean'][0]
        sales1_val.at[4 * i + 1, 'Prediction (IMAPA)'] = fcast['mean'][1]
        sales1_val.at[4 * i + 2, 'Prediction (IMAPA)'] = fcast['mean'][2]
        sales1_val.at[4 * i + 3, 'Prediction (IMAPA)'] = fcast['mean'][3]
    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 4, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 4, ["Prediction (IMAPA)"]].values
        error_sales1.at[t, 'MAE (IMAPA)'] = mae(actual, forecast)

    model = ADIDA()
    for i in range(0, len(sales1_test.axes[0])):
        demand = sales1_train_y[Horizon * i:Horizon * (i + 1)].values
        fit3 = model.fit(demand)
        fcast = model.predict(h=4)
        sales1_val.at[4 * i, 'Prediction (ADIDA)'] = fcast['mean'][0]
        sales1_val.at[4 * i + 1, 'Prediction (ADIDA)'] = fcast['mean'][1]
        sales1_val.at[4 * i + 2, 'Prediction (ADIDA)'] = fcast['mean'][2]
        sales1_val.at[4 * i + 3, 'Prediction (ADIDA)'] = fcast['mean'][3]
    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 4, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 4, ["Prediction (ADIDA)"]].values
        error_sales1.at[t, 'MAE (ADIDA)'] = mae(actual, forecast)

    model = CrostonOptimized()
    for i in range(0, len(sales1_test.axes[0])):
        demand = sales1_train_y[Horizon * i:Horizon * (i + 1)].values
        fit3 = model.fit(demand)
        fcast = model.predict(h=4)
        sales1_val.at[4 * i, 'Prediction (Croston Optimized)'] = fcast['mean'][0]
        sales1_val.at[4 * i + 1, 'Prediction (Croston Optimized)'] = fcast['mean'][1]
        sales1_val.at[4 * i + 2, 'Prediction (Croston Optimized)'] = fcast['mean'][2]
        sales1_val.at[4 * i + 3, 'Prediction (Croston Optimized)'] = fcast['mean'][3]
    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 4, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 4, ["Prediction (Croston Optimized)"]].values
        error_sales1.at[t, 'MAE (Croston Optimized)'] = mae(actual, forecast)

    model = CrostonSBA()
    for i in range(0, len(sales1_test.axes[0])):
        demand = sales1_train_y[Horizon * i:Horizon * (i + 1)].values
        fit3 = model.fit(demand)
        fcast = model.predict(h=4)
        sales1_val.at[4 * i, 'Prediction (Croston SBA)'] = fcast['mean'][0]
        sales1_val.at[4 * i + 1, 'Prediction (Croston SBA)'] = fcast['mean'][1]
        sales1_val.at[4 * i + 2, 'Prediction (Croston SBA)'] = fcast['mean'][2]
        sales1_val.at[4 * i + 3, 'Prediction (Croston SBA)'] = fcast['mean'][3]
    for t in range(0, len(sales1_test.axes[0])):
        actual = sales1_val.loc[4 * t:4 * t + 4, ["Sales"]].values
        forecast = sales1_val.loc[4 * t:4 * t + 4, ["Prediction (Croston SBA)"]].values
        error_sales1.at[t, 'MAE (Croston SBA)'] = mae(actual, forecast)

    def winner(row):
        minimum = min(row['MAE (Moving Average)'], row['MAE (Croston)'], row['MAE (TSB)'], row['MAE (IMAPA)'],
                      row['MAE (ADIDA)'], row['MAE (Croston Optimized)'], row['MAE (Croston SBA)'])
        if minimum == row['MAE (Moving Average)']:
            return 'Moving Average'
        elif minimum == row['MAE (Croston)']:
            return 'Croston'
        elif minimum == row['MAE (TSB)']:
            return 'TSB'
        elif minimum == row['MAE (ADIDA)']:
            return 'ADIDA'
        elif minimum == row['MAE (Croston Optimized)']:
            return 'Croston Optimized'
        elif minimum == row['MAE (Croston SBA)']:
            return 'Croston SBA'
        else:
            return 'IMAPA'

    error_sales1['Winner'] = error_sales1.apply(winner, axis=1)

    go = error_sales1.loc[:,
         ['MAE (Croston)', 'MAE (Moving Average)', 'MAE (TSB)', 'MAE (IMAPA)', 'MAE (ADIDA)', 'MAE (Croston Optimized)',
          'MAE (Croston SBA)']]
    method = go.idxmin(axis=1)

    for i in range(0, len(sales1_test.axes[0])):
        if method[i] == 'MAE (Croston)':
            demand = sales1_train_y2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)].to_list()
            demand_df = pd.Series(demand)
            fit3 = croston.fit_croston(demand_df, 1, 'original')
            fcast = fit3['croston_forecast']
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast[0])
        elif method[i] == 'MAE (TSB)':
            model = TSB(alpha_d=0.5, alpha_p=0.5)
            demand = sales1_train_y2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)].values
            fit3 = model.fit(demand)
            fcast = model.predict(h=1)
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast['mean'][0])
        elif method[i] == 'MAE (IMAPA)':
            model = IMAPA()
            demand = sales1_train_y2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)].values
            fit3 = model.fit(demand)
            fcast = model.predict(h=1)
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast['mean'][0])
        elif method[i] == 'MAE (ADIDA)':
            model = ADIDA()
            demand = sales1_train_y2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)].values
            fit3 = model.fit(demand)
            fcast = model.predict(h=1)
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast['mean'][0])
        elif method[i] == 'MAE (Croston SBA)':
            model = CrostonSBA()
            demand = sales1_train_y2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)].values
            fit3 = model.fit(demand)
            fcast = model.predict(h=1)
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast['mean'][0])
        elif method[i] == 'MAE (Croston Optimized)':
            model = CrostonOptimized()
            demand = sales1_train_y2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)].values
            fit3 = model.fit(demand)
            fcast = model.predict(h=1)
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast['mean'][0])
        else:
            demand = sales1_train2[(Horizon + 4) * i:(Horizon + 4) * (i + 1)][["WeekOrder", "Sales"]]
            new_rows = [{'WeekOrder': (Horizon + 5), 'Sales': 0}]
            demand = demand.append(new_rows, ignore_index=True)
            demand.set_index('WeekOrder', inplace=True)
            sma = demand.rolling(window=4).mean()
            demand["Sales"][(Horizon + 4)] = math.ceil(sma["Sales"][(Horizon + 4)])
            demand = demand.reset_index()
            fcast = sma["Sales"][(Horizon + 5)]
            sales1_test.at[i, 'Prediction'] = math.ceil(fcast)

    Pred = pd.concat([Pred, sales1_test])
    Pred.drop(columns='Sales', inplace=True)
    Error = pd.concat([Error, error_sales1])

    return Pred

intermittent(file, Zone)