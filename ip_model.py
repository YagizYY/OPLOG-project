"""
NOT: Gurobi çalıştırmak adına: https://www.gurobi.com/free-trial/
"""

import numpy as np
from gurobipy import * #Integer program için kullanılan solver, gurobi.
import pandas as pd

def AllocationModel(demand, supply): #Model UI kısmında fonksiyon olarak çağırılmak adına burada bu şekilde tanımlanıldı.

    #indices
    W = [0,1,2,3,4] #Fulfillment Center indexleri, 0 & 1 = Kocaeli, 2 = İzmir, 3 = İstanbul, 4 = Ankara.
    L = [0,1,2,3,4] #Clusterların indexleri.
    K = [k for k in range(0, 134793)] #SKU indexleri.

    P = 999999 #Backlog için uygulanacak olan penalty, bu şekilde model elinde varken yollamak durumunda yüksek bir penalty olduğundan.
    H = 20 #Kapasite hacim parametresi.
    F = 9999 #Excess (network bazında) envanter için konulan penalty, bu durumda genel tüm fulfillmentlarda yer varsa model envanteri kabul etmek durumunda yüksek bir penalty olduğundan.

    #Indexlerin (1,1) veya (1,1,1) şeklinde tanımlanmaları, bunlar karar değişkenlerini tanımlarken kullanılacak.
    Arc = [(i,j) for i in W for j in L]
    wareskuzone = [(i,j,k) for i in W for j in L for k in K]
    waresku = [(i,k) for i in W for k in K]
    zonesku = [(j,k) for j in L for k in K]
    waretoware = [(i1,i2) for i1 in W for i2 in W]
    inter = [(i1,i2,k) for i1 in W for i2 in W for k in K]

    #Parametreler

    #Fullfilment Center - Cluster arasındaki varış süresinin parametresi.
    Travel = np.array([[10.49968449,3.451872877,2.4322763,2.366242421,4.629267556],
    [10.49968449,3.451872877,2.4322763,	2.366242421,4.629267556],
    [13.05126891,6.710048565,1.850195026,2.964778048,6.889157144],
    [11.41643396,4.354153039,2.407109643,1.450601434,5.511426839],
    [7.408809789,1.160940077,4.10293231,5.475971203,1.639130532]])
    T = {(i,j): Travel[i][j] for i,j in Arc}

    #Demand parametresi, okutulan dosya 101. hafta için yapılan forecastler.
    #Demand = pd.read_csv("Week1_Forecast.csv", index_col=0)
    Demand = demand
    D = {(j,k): Demand.iloc[k,j] for j,k in zonesku}

    #Replenishment parametresi, okutulan dosya 101. hafta için eski satış verileri.
    #Supply = pd.read_csv("Week1_Supply.csv", index_col=0)
    Supply = supply
    S = {k: Supply[k] for k in K}

    #Hacim parametresi, bir unit olarak alındı her SKU için.
    Volume = np.random.randint(1,2, size= 134793)
    V = {k: Volume[k] for k in K}

    #Başlangıç envanteri, bu noktada validation için elde envanter olmadan başlanılcağı varsayıldığından şu noktada sıfır olarak oluşturuldu.
    Initial = np.random.randint(0,1, size = (5,134793))
    I0 = {(i,k): Initial[i][k] for i,k in waresku}

    #Fullfilment Centerların hacim bazında kapasite bilgisi, şu noktada yüksek bir değer olarak verildi.
    Capacity = np.random.randint(9999998,9999999 , size=(5))
    C = {i: Capacity[i] for i in W}


    #MODEL:
    mdl = Model("Inventory Allocation")

    #Karar değişkenlerinin tanımlanması:

    y = mdl.addVars(wareskuzone, lb=0.0, vtype = GRB.INTEGER, name ="y")    #y[i,j,k] : Fullfilment Center i'den, Cluster j'ye yollanan SKU k miktarı.
    B = mdl.addVars(zonesku, lb = 0.0, vtype= GRB.INTEGER, name = "B")      #B[j,k] : Cluster j'de backloga düşen SKU k miktarı.
    E = mdl.addVars(K, lb = 0.0, vtype= GRB.INTEGER, name = "E") #          E[k] : Network'e kabul edilmeyen SKU k miktarı.
    Z = mdl.addVars(inter, lb= 0.0, vtype= GRB.INTEGER, name = "Z")         #Z[i1,i2,k] : Fullfilment Center i1'den, FC i2'ye giren SKU k miktarı.
    N = mdl.addVars(waretoware, lb=0.0, vtype= GRB.INTEGER, name = "N")     #N[i,k] : Fullfilment Center i1'den FC i2'ye çıkan inter-transfer araç sayısı.
    A = mdl.addVars(waresku, lb= 0.0, vtype=GRB.INTEGER, name="A")          #A[i,k] : Fulfillment Center i'ye alokasyon yapılan SKU k sayısı.
    Q = mdl.addVars(waresku, lb= 0.0, vtype=GRB.BINARY, name="Q")           #Q[i,k] : Depolar arası döngüyü engelleyen binary variable.

    #Objective Function
    mdl.modelSense = GRB.MINIMIZE
    mdl.setObjective(quicksum((T[i,j]*quicksum(y[i,j,k] for k in K)) for i in W for j in L) + P*quicksum(B[j,k] for j,k in zonesku) + F*quicksum(E[k] for k in K))

    #Kısıtlar

    #1: FC i'den Cluster j'ye yollananlar + backloglar demandden büyük olmalı. Buradaki backlog karar değişkeni modelin infeasible çıkmasını engelliyor aynı zamanda.
    mdl.addConstrs(quicksum(y[i,j,k] for i in W) + B[j,k] >= D[j,k] for j,k in zonesku);

    #2: FC i'den Cluster j'ye yollanan SKU k, o FC'de olan total envanterden az olmalı (elinde olandan fazlasını yollayamaz).
    mdl.addConstrs(quicksum(y[i,j,k] for j in L)  <= A[i,k] + quicksum(Z[i1,i,k] for i1 in W) - quicksum(Z[i,i2,k] for i2 in W) + I0[i,k] for k in K for i in W);

    #3: Eldeki envanterler, gelen inter-transferler ve çıkan inter-transferler sonrası oluşan envanter sayısı deponun kapasitesinden küçük olmalı.
    mdl.addConstrs(quicksum(V[k]*(I0[i,k] + A[i,k] + quicksum(Z[i1,i,k] for i1 in W) - quicksum(Z[i,i2,k] for i2 in W)) for k in K) <= C[i] for i in W);

    #4: Bir depodan çıkan inter-transferler, o depoya gelen inter-transferlerden ve eldeki envanterden küçük olmalı (elinde olandan fazlasını yollayamaz.)
    mdl.addConstrs(I0[i, k] + quicksum(Z[i1, i, k] for i1 in W) >= quicksum(Z[i, i2, k] for i2 in W) for k in K for i in W);

    #5: Inter-transfer ancak tır kapasitesi triggerlandığında, kapasiteyi tam dolduracak şekilde gönderilebilir.
    mdl.addConstrs(quicksum(V[k]*Z[i1,i2,k] for k in K) == H*N[i1,i2] for i2 in W for i1 in W);

    #6: Model sonucunda depoların kendilerinden kendilerine inter-transferlerini önlemek adına:
    mdl.addConstrs(Z[i,i,k] == 0 for i in W for k in K)

    #7: Allocate edilen total miktar, sağlanan replenishment eksi excess envantere eşit (networkte yer olmaması durumunda alınamayan miktarı kullanıcıya vermek ve replenishmenttan azaltmak adına=.
    mdl.addConstrs(quicksum(A[i,k] for i in W) == S[k] - E[k] for k in K)

    #8:
    mdl.addConstrs(quicksum(V[k]*E[k] for k in K) >= quicksum(V[k]*I0[i,k] for k in K) + quicksum(V[k]*S[k] for k in K) - quicksum(C[i] for i in W) for i in W);

    #9
    #mdl.addConstrs(quicksum(Z[i,i2,k] for i2 in W) <= P*Q[i,k] for i in W for k in K);
    #10
    #mdl.addConstrs(quicksum(Z[i1,i,k] for i1 in W) <= P*(1-Q[i,k]) for i in W for k in K);



    mdl.optimize() #Kurulan modeli çalıştırmak için.

    #Çıkan sıfırdan farklı karar değişken sonuçlarını dataframe şeklinde tutup, aynı zamanda .csv olarak kaydetmek için:
    var_names = []
    var_values = []
    for var in mdl.getVars():
        if var.X != 0:
            var_names.append(str(var.varName))
            var_values.append(var.X)

    df1 =pd.DataFrame({"Variable": var_names, "Value": var_values})
    df1.to_csv("Model-NonZero.csv")

    # Allocation of Kocaeli1
    Allocation_Kocaeli1 = []
    Values_Kocaeli1 = []
    for k in K:
        var_names = str(A[0,k]).split()[1]
        Allocation_Kocaeli1.append(var_names)
        Values_Kocaeli1.append(A[0,k].X)
    Kocaeli1 = pd.DataFrame({"Kocaeli (1) Allocation": Allocation_Kocaeli1, "Value": Values_Kocaeli1})


    # Allocation of Kocaeli2
    Allocation_Kocaeli2 = []
    Values_Kocaeli2 = []
    for k in K:
        var_names = str(A[1,k]).split()[1]
        Allocation_Kocaeli2.append(var_names)
        Values_Kocaeli2.append(A[1,k].X)
    Kocaeli2 = pd.DataFrame({"Kocaeli (2) Allocation": Allocation_Kocaeli2, "Value": Values_Kocaeli2})

    # Allocation of İzmir
    Allocation_İzmir = []
    Values_İzmir = []
    for k in K:
        var_names = str(A[2,k]).split()[1]
        Allocation_İzmir.append(var_names)
        Values_İzmir.append(A[2,k].X)
    İzmir = pd.DataFrame({"İzmir Allocation": Allocation_İzmir, "Value": Values_İzmir})

    # Allocation of İstanbul
    Allocation_İstanbul = []
    Values_İstanbul = []
    for k in K:
        var_names = str(A[3,k]).split()[1]
        Allocation_İstanbul.append(var_names)
        Values_İstanbul.append(A[3,k].X)
    İstanbul = pd.DataFrame({"İstanbul Allocation": Allocation_İstanbul, "Value": Values_İstanbul})

    # Allocation of Ankara
    Allocation_Ankara = []
    Values_Ankara= []
    for k in K:
        var_names = str(A[4,k]).split()[1]
        Allocation_Ankara.append(var_names)
        Values_Ankara.append(A[4,k].X)
    Ankara = pd.DataFrame({"Ankara Allocation": Allocation_Ankara, "Value": Values_Ankara})


    # Yukarıdaki ile benzer olarak, validation'a input girişi sağlamak adına sadece allocation değerlerinin .csv dosyasını oluşturmak adına:
    #Allocation = []
    #for v in mdl.getVars():
        #if "A" in v.VarName:
            #Allocation.append(f"{v.X}")
    #df2 = pd.DataFrame({"(Fulfillment Center, SKU)": waresku, "Value": Allocation})
    #df2.to_csv("Allocation-All.csv")

    #For y variables.
    Sent = []
    Val_Sent = []

    for var in mdl.getVars():
        if "y" in var.Varname:
            if var.X != 0:
                Sent.append(str(var.varName))
                Val_Sent.append(var.X)

    Sent_y =pd.DataFrame({"Sent Amounts (FC(i), Cluster(j), SKU(k))": Sent, "Value": Val_Sent})

    #For Inter-transfers.
    Transfer = []
    Val_Transfer = []

    for var in mdl.getVars():
        if "Z" in var.Varname:
            if var.X != 0:
                Transfer.append(str(var.varName))
                Val_Transfer.append(var.X)

    Transfer_Z = pd.DataFrame({"Inter-transfer Amounts (FC(i1), FC(i2), SKU(k))": Transfer, "Value": Val_Transfer})

    #For Trucks
    Truck = []
    Val_Truck = []

    for var in mdl.getVars():
        if "N" in var.Varname:
            if var.X != 0:
                Truck.append(str(var.varName))
                Val_Truck.append(var.X)

    Truck_N = pd.DataFrame({"Truck Number (FC(i1), FC(i2))": Truck, "Value": Val_Truck})

    #For Backlog
    Backlog = []
    Val_Backlog = []

    for var in mdl.getVars():
        if "B" in var.Varname:
            if var.X != 0:
                Backlog.append(str(var.varName))
                Val_Backlog.append(var.X)

    Backlog_B = pd.DataFrame({"Backlog Amounts (Cluster(j), SKU(k))": Backlog, "Value": Val_Backlog})

    #For Excess
    Excess = []
    Val_Excess = []

    for var in mdl.getVars():
        if "E" in var.Varname:
            if var.X != 0:
                Excess.append(str(var.varName))
                Val_Excess.append(var.X)

    Excess_E = pd.DataFrame({"Excess Amounts (SKU(k))": Excess, "Value": Val_Excess})


    Outputs = pd.concat([Kocaeli1,Kocaeli2, İstanbul, İzmir, Ankara, Sent_y, Transfer_Z, Truck_N, Backlog_B, Excess_E], axis="columns")

    return Outputs



