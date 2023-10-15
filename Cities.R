tur_city <- c("istanbul","ankara","izmir","adana","adiyaman","afyon","agri",
"aksaray","amasya","antalya","ardahan","artvin","aydin","balikesir","bartin"
,"batman","bayburt",
"bilecik","bingol","bitlis","bolu","burdur","bursa","canakkale","cankiri",
"corum","denizli","diyarbakir","duzce","edirne","elazig","erzincan","erzurum",
"eskisehir","antep","giresun","gumushane","hakkari","hatay","igdir",
"isparta","maras","karabuk","karaman","kars",
"kastamonu","kayseri","kilis","kirikkale","kirklareli","kirsehir","kocaeli",
"konya","kutahya","malatya","manisa","mardin","mersin","mugla","mus",
"nevsehir","nigde","ordu","osmaniye","rize","sakarya","samsun","urfa",
"siirt","sinop","sirnak","sivas","tekirdag","tokat","trabzon","tunceli","usak"
,"van","yalova","yozgat","zonguldak")



district_ankara <- c("altindag", "ayas", "bala", "beypazari", "camlidere", 
           "cankaya", "cubuk", "etimesgut", "haymana", "kalecik", "kecioren",
                     "kizilcahamam", "mamak", "nallihan", "polatli","pursaklar",
                     "sereflikochisar", "sincan", "cayyolu","beysukent",
                     "yenimahalle", 06, "akyurt","baglica", "yenimahalle",
           "umitkoy", "soguksu", "mebusevleri", "eryaman","anittepe")

district_istanbul <- c("Adalar","Atasehir", "acibadem","bagcilar", "bayrampasa",
                       "Bahcelievler", "levent", 
                       "Bakirkoy", "basaksehir","atasehir","avcilar","cekmece",
                        "Beykoz", "Beyoglu","Beylikduzu", 
                       "Buyukcekmece", "cekmekoy","fatih",
                       "Catalca", "Eminonu", "Esenler", "Eyup","Eyupsultan",
                       "Fatih","Esenyurt","Sancaktepe","Uskudar",
                       "Gaziosmanpasa", "Gungoren", "Kadikoy", "Kagithane", 
                       "Kartal", "Kucukcekmece", "Maltepe", "Pendik", 
                       "Sariyer", "Silivri", "Sile", "Sisli", "Sultanbeyli",
                       "maslak","suadiye","esentepe",
                       "Tuzla", "Umraniye", "Uskudar", "Zeytinburnu",
                       "tesvikiye","taksim","atakoy", 34,"arnavutkoy",
                       "beylikduzu","beykoz","besiktas", "beykent","bostanci",
                       "emirgan","caddebostan","camlica","cengelkoy","buyukada",
                       "cevizli", "zeytinburnu", "yesilkoy","umraniye",
                       "sultangazi", "sefakoy", "hisari", "polonezkoy",
                     "mecidiyekoy", "kucukyali","küçükbakkalköy", "kozyatagi",
                       "küçüksu", "kavacik", "karakoy", "istinye","halkali",
                     "feneryolu","etimesgut","etiler")

district_izmir <- c("Aliaga","Alacati", "Balcova", "Bayindir", "Bergama",
                    "Beydag", "Bornova", "Buca", "Cesme", "Dikili", "Foca", 
                    "Guzelbahce", "Karaburun", "Karsiyaka", "Kemalpasa",
                    "Konak", "Kiraz", "Konak", "Menderes", "Menemen", 
                    "Narlidere", "Gaziemir", "Seferihisar", "Selcuk", "Tire",
                    "Torbali", "Urla", "cigli","bayrakli", 35,"alsancak",
                    "bostanli", "odemis", "karabaglar","goztepe")

district_adana <- c("Aladağ", "Ceyhan", "Feke", "Karaisali", "Kozan", 
                    "Pozanti", "Saimbeyli", "Seyhan", "Yumurtali", "Yüreğir",
                    01, "cukurova")

district_adiyaman <- c("Besni", "Gölbaşi", "Kahta",02)

district_afyon <- c("Başmakçi", "Bolvadin", "Çay", "Çobanlar", "Dinar", 
          "Emirdağ", "İhsaniye", "Kizilören","Sandikli", "Sincanli", "Suhut", 
                    "Sultandaği",03)

district_agri <- c("Diyadin", "Doğubeyazit", "Patnos", "Tutak",04,"dogubeyazit",
                   "dogubayazit")

district_aksaray <- c("Eskil", "Gülağaç", "Güzelyurt", 68)

district_amasya <- c("Göynücek", "Gümüşhaciköy", "Merzifon", "Suluova", 
                     "Taşova", 05)

district_antalya <- c("Akseki", "Alanya", "Elmali", "Finike", "Gazipasa",
                    "Ibradi","Kale", "Kas", "Korkuteli", "Kumluca","Konyaalti",
                      "Kepez","Manavgat","Aksu", "Serik","Kemer", 07, 
                    "muratpasa", "dosemealti")

district_ardahan<- c("Çildir", "Göle", 75)

district_artvin<- c("Ardanuc", "Arhavi", 08,"Hopa", "Murgül", "Savsat", 
                    "Yusufeli")

district_aydin <- c("Bozdoğan", 09,"Buharkent", "Çine", "Germencik", 
                    "İncirliova", "didim", "efeler",
                    "Karacasu", "Karpuzlu", "Koçarli", "Köşk", "Kuşadasi", 
        "Kuyucak", "Nazilli", "Söke", "Sultanhisar", "Yenihisar", "Yenipazar")

district_balikesir <- c("Ayvalik", "Balya", "Bandirma", "Bigadiç", "Burhaniye",
        "Dursunbey", "Edremit", "Erdek", "Gömeç", "Gönen", "Havran", "İvrindi", 
        "Kepsut", "Manyas", "Savaştepe", "Sindirgi", "Susurluk",10,"altieylül",
        "karesi")

district_bartin<- c("Amasra", "Ulus",74)
district_batman<- c("Hasankeyf",72)

district_bayburt<- c("Aydintepe", "Demirözü",69)

district_bilecik <- c("Bozhüyük", "Gölpazari", "Osmaneli", "Pazaryeri", "Söğüt",
                      11, "bozuyuk")

district_bingol <- c("Adakli", "Genç", "Karliova", "Kiği", "Solhan", 
                     "Yayladere", "Yedisu",12)

district_bitlis <- c("Adilcevaz", "Ahlat", 13,"Güloymak", "Mutki", "Tatvan")

district_bolu <- c("Dörtdivan", "Gerede", "Göynük", 14,"Mengen", "Mudurnu", 
                   "Yeniçağa")

district_burdur <- c("Ağlasun", "Bucak", "Çavdir", 15,"Gölhisar", "Karamanli",
                     "Tefenni", "Yeşilova")

district_bursa <- c("Gemlik", "Gursu", "Inegol", "Iznik", "Karacabey", "Keles",
                    "Kestel", "Mudanya", "MustafaKemalpasa", "Nilufer", 
                    "Orhaneli", "Orhangazi", "Osmangazi",16, "Yenisehir",
                    "Yildirim",2)

district_canakkale<- c("Ayvacik", "Bayramiç", "Biga", "Bozcaada", "Çan", 
                       "Eceabat", "Ezine", "Gölbaşi", "Gökçeada",17, "Lapseki", 
                       "Yenice")

district_cankiri <- c("Atkaracalar", "Bayramören", "Çerkeş", "Eldivan",18, 
                      "Ilgaz", "Kurşunlu", "Orta", "Şabanözü", "Yaprakli")

district_corum <- c("Alaca", "Boğazkale", "Iskilip", "Kargi", "Mecitözü",
                    "Oğuzlar", "Osmancik", "Sungurlu", "Uğurludağ",19)

district_denizli <- c("Acipayam", "Babadağ", "Buldan", "Çal", "Çardak",20, 
                      "Çivril", "Güney", "Holaz", "Kale", "Sarayköy", "Tavaş",
                      "pamukkale", "merkezefendi")

district_diyarbakir <- c("Çermik", "Eğil", "Ergani", "Hani", "Hazro", 21,
                         "Kocaköy", "Lice", "Silvan", "baglar", "kayapinar")

district_duzce <- c("Akçakoca", "Çilimli", "Yiğilca", 81)

district_edirne <- c("Enes", "Havsa", "İpsala", "Keşan", "Lalapaşa", "Meriç", 
                     "Uzunköprü",22)

district_elazig <- c("Ağin", "Aricak",23, "Baskil", "Karakoçan", "Keban", 
                     "Kovancilar", "Maden", "Palu", "Sivrice")

district_erzincan <- c("Çayirli", "Iliç",24, "Kemah", "Kemaliye", "Refahiye", 
                       "Tercan", "Üzümlü")

district_erzurum <- c("Aşkale", "Hinis", 25,"Horasan", "Ilica", "İspir", 
                      "Narman", "yakutiye", "palandoken",
                      "Oltu", "Olur", "Pasinler", "Tortum")

district_eskisehir <- c("Alpu",26, "Beylikova", "Çifteler", "Günyüzü", "Han", 
                "İnönü", "Mahmudiye", "Mihaliçcik", "Seyitgazi", "Sivrihisar",
                "tepebasi")

district_antep <- c("Araban", "Islahiye",27, "Nizip", "Nurdaği", "Oğuzeli", 
                        "Şahinbey", "Şehitkamil", "Yavuzeli")

district_giresun <- c("Alucra", "Bulancak", 28,"Dereli", "Espiye", "Eynesil", 
                      "Görele", "Keşap", "Şebinkarahisar", "Tirebolu")

district_gumushane <- c("Kelkit", "Kurtun", "Şiran", 29)

district_hakkari <- c("Çukurca", "Şemdilli", "Yüksekova", 30)

district_hatay <- c("Altinözü", "Belen", "Dörtyol", "Yüksekova", "Erzin", 
                    "İskenderun", "Kirikhan", "Kumlu", "Reyhanli", "Samandaği", 
                    "Yayladaği", 31, "arsuz", "samandag")

district_igdir <- c("Aralik", "Karakoyunlu", 76,"Tuzluca")

district_isparta <- c("Aksu", "Atabey", "Eğirdir", "Gelendost", "Gönen", 
                      "Keçiborlu", "Sarkikaraağaç", "Senirkent", "Sütçüler", 
                      "Uluborlu", "Yalvaç",32)

district_maras <- c("Afşin", "Andirin", "Çağlayancerit", "Elbistan", 
                            "Göksun", "Pazarcik",46, "onikisubat" )

district_karabuk <- c("Eskipazar", "Safranbolu", 78)

district_karaman <- c("Ayranci", "Başyayla", "Ermenek",70)

district_kars <- c("Kağizman", "Sarikamiş", 36)

district_kastamonu <- c("Abana", "Arac", "Bozkurt", "Çatalzeytin", "Cide", 
      "Daday", "Devrenkani", "Hanönü", "İhsangazi", "İnebolu", "Küre",  
      "Taşköprü", "Tosya",37)

district_kayseri <- c("Akkişla", "Bünyan", "Develi", "Felahiye", "Hacilar", 
        "İncesu", "Kocasinan", "Melekgazi", "Özvatan", "Pinarbaşi", "Talas",
        "Tomarza", "Yahyali", "Yeşilhisar",38, "melikgazi")

district_kilis <- c("Elbeyli",   "Musabeyli", "Polateli",79)

district_kirikkale <- c("Karakeçili", "Keskin",   "Sulakyurt",71)

district_kirklareli <- c("Babaski", "Lüleburgaz",   "Pehlivanköy", 
                         "Pinarhisar", "Vize", 39,"babaeski")

district_kirsehir <- c("Akpinar", "Çiçekdaği", "Kaman",   "Mucur")

district_kocaeli <- c("Derince", "Gebze", "Gölcük", "Kandira", "Karamürsel",41,
                      "basiskele", "korfez", "kartepe", "dilovasi","darica")


district_konya <- c("Akören", "Akşehir", "Altinekin", "Beyşehir", "Bozkir", 
        "Çeltik", "Cihanbeyli", "Çumra", "Derbent", "Doğanhisar", "Emirgazi", 
      "Ereğli", "Hadim", "Hüyük", "Ilgin", "Kadinhani", "Karapinar", "Karatay", 
            "Meram", "Sarayönü", "Selçuklu", "Seydişehir", "Taşkent", "Yunak",
      42)


district_kutahya <- c("Altintaş", "Domaniç", "Dumlupinar", "Emet", "Gediz",
                      "Pazarlar", "Simav", "Tavşanli",43)

district_malatya <- c("Akçadağ", "Arapkir", "Arguvan", "Battalgazi", "Darende", 
                "Doğanşehir", "Hekimhan", "Pötürge", "Yazihan", "Yeşilhan",44)

district_manisa <- c("Ahmetli", "Akhisar", "Alaşehir", "Demirci", "Gölmarmara",
    "Gördes", "Kirkağaç", "Kula", "Salihli", "Sarihanli", "Soma", "Turgutlu",
    45, "yunusemre", "sehzadeler")

district_mardin <- c("Derik", "Kiziltepe", "Mazidaği", "Midyat", "Nusaybin", 
                     "Ömerli", "Savur",47)

district_mersin <- c("Anamur", "Bozyazi", "Çamliyayla", "Erdemli", "Gülnar", 
                     "Mut", "Silifke", "Tarsus",33, "mezitli")

district_mugla <- c("Bodrum", "Datça", "Fethiye", "Kavaklidere", "Köyceğiz", 
                    "Marmaris", "Milas", "Ortaca", "Ula", "Yatağan",48,
                    "dalaman")

district_mus <- c("Bulanik", "Korkut", "Malazgirt", 49)

district_nevsehir <- c("Avanos", "Derinkuyu", "Gülşehir", "Hacibektaş", 
                       "Kozakli", "Ürgüp", 50)

district_nigde <- c("Altunhisar", "Bor", "Çamardi", "Çiftlik", "Ulukişla",51)

district_ordu <- c("Akkuş", "Fatsa", "Görköy", "Kabadüz", "Mesudiye", 
                   "Perşembe", "Ulubey", "Ünye", 52)

district_osmaniye <- c("Bahçe", "Kadirli", 80)

district_rize <- c("Ardeşen", "Çayeli", "Findikli", "Pazar", "Çamlihemşin",53)

district_sakarya <- c("Akyazi",  "Hendek", "Karasu","Sapanca","Serdivan",
                      "Adapazari","Erenler","Arifiye", 54)

district_samsun <- c("Alacam", "Bafra", "Carsamba", "Havza", "Kavak", "Ladik",
                     "Salipazari", "Tekkekoy", "Terme","Atakum", "Vezirkopru",
                     55, "ilkadim")

district_urfa <- c("Akçakale", "Birecik", "Bozova", "Halfeti", "Harran", 
                        "Hilvan", "Siverek", "Suruç", "Viranşehir",63,
                   "karakopru")

district_siirt <- c("Aydinlar", "Baykan", "Eruh", "Kurtalan",56)

district_sinop <- c("Ayancik", "Boyabat", "Durağan", "Elfelek", "Gerze",57)

district_sirnak <- c("Cizre", "İdil",  "Silopi",73)

district_sivas <- c("Altinyayla", "Divriği", "Doğansar", "Gemerek", "Hafik", 
                    "Kangal", "Şarkişla", "Suşehri", "Yilizeli", "Zara", 58)

district_tekirdag <- c("Çerkezköy", "Çorlu", "Hayrabolu", "Malkara", 
                       "MarmaraEreğlisi", "Muratli", "Saray", "Şarköy",59,
                       "suleymanpasa", "kapakli")

district_tokat <- c("Almuz", "Erbaa", "Niksar", "Pazar", "Reşadiye", 60, 
                    "Sulusaray", "Turhal", "Zile")

district_trabzon <- c("Akçabat", "akcaabat","Arakli", "Arşin", "Beşikdüzü", 
                      "Çarşibaşi", 
                "Çaykara", "Dernekpazari", "Maçka","Of", "Sürmene", "Tonya",
                      "Vakfikebir", "Yomra", 61)

district_tunceli <- c("Çemişgezek", "Hozat", "Mazgirt", "Nazimiye", "Pertek",
                      62)

district_usak <- c("Banaz", "Eşme", "Sivasli", "Ulubey",64)

district_van <- c("Başkale", "Çaldiran", "Çatak", "Erciş", "Gevaş", "Gürpinar", 
                  "Muradiye", "Özalp", "ipekyolu", 65)

district_yalova <- c("Altinova", "Armutlu", 77)

district_yozgat<- c("Boğazliyan", "Çandir", "Çayiralan", "Sarikaya", 
                    "Sefaatli", "Sorgun", "Yenifakili", "Yerköy",66)

district_zonguldak <- c("Arapli", "Çaycuma", "Devrek", "Ereğli",67, "kozlu")


