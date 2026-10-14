import csv,random,sqlite3,zipfile,xml.etree.ElementTree as ET,datetime as dt,calendar,os,shutil,collections,math,json
from pathlib import Path
R=random.Random(20261014)
BASE=Path('/mnt/data/GreenTrail_Expanded'); BASE.mkdir(exist_ok=True)
SRC=Path('/mnt/data/GreenTrail Store Data.xlsx')
Z=zipfile.ZipFile(SRC); ns={'m':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
root=ET.fromstring(Z.read('xl/sharedStrings.xml')); ss=[''.join(x.itertext()) for x in root]
root=ET.fromstring(Z.read('xl/worksheets/sheet1.xml'))
raw=[]
for row in root.findall('.//m:sheetData/m:row',ns):
 vals=[]
 for c in row.findall('m:c',ns):
  v=c.find('m:v',ns); ins=c.find('m:is',ns); val=v.text if v is not None else ''.join(ins.itertext()) if ins is not None else ''
  vals.append(ss[int(val)] if c.get('t')=='s' and val else val)
 raw.append(vals)
headers=raw[0]
def exceldate(x):return (dt.date(1899,12,30)+dt.timedelta(days=int(float(x)))).isoformat()
original=[]
for r in raw[1:]:
 d=dict(zip(headers,r));original.append((int(d['Store ID']),d['Location'],int(d['Store Size']),d['Store Type'],int(d['Promotion ID']),d['Type of Promotion'],exceldate(d['Promotion Start Date']),exceldate(d['Promotion End Date']),*[float(d[k]) for k in headers[8:]]))
conn=sqlite3.connect(str(BASE/'greentrail_retail.sqlite'));c=conn.cursor();c.executescript('''PRAGMA journal_mode=OFF; PRAGMA synchronous=OFF;
CREATE TABLE original_promotion_observations(store_id INTEGER, location TEXT,store_size_sqft INTEGER,store_type TEXT,promotion_id INTEGER,promotion_type TEXT,start_date TEXT,end_date TEXT,weekly_sales_during REAL,weekly_sales_before REAL,weekly_sales_after REAL,avg_daily_visits_during REAL,avg_daily_visits_before REAL,avg_daily_visits_after REAL,record_origin TEXT NOT NULL DEFAULT 'ORIGINAL_UPLOADED',PRIMARY KEY(store_id,promotion_id));
CREATE TABLE stores(store_id INTEGER PRIMARY KEY,city TEXT,state TEXT,region TEXT,store_type TEXT,store_size_sqft INTEGER,opening_date TEXT,is_original_store INTEGER,record_origin TEXT);
CREATE TABLE products(product_id INTEGER PRIMARY KEY,sku TEXT UNIQUE,product_name TEXT,category TEXT,unit_price REAL,unit_cost REAL,sustainable_flag INTEGER,sustainability_score INTEGER,record_origin TEXT);
CREATE TABLE customer_segments(segment_id INTEGER PRIMARY KEY,segment_name TEXT,description TEXT,record_origin TEXT);
CREATE TABLE promotions(promotion_id INTEGER PRIMARY KEY,promotion_type TEXT,start_date TEXT,end_date TEXT,discount_rate REAL,budget_usd REAL,objective TEXT,record_origin TEXT);
CREATE TABLE store_promotion_assignments(promotion_id INTEGER,store_id INTEGER,assignment_group TEXT,assignment_method TEXT,record_origin TEXT,PRIMARY KEY(promotion_id,store_id));
CREATE TABLE transactions(transaction_id INTEGER PRIMARY KEY,store_id INTEGER,transaction_date TEXT,segment_id INTEGER,promotion_id INTEGER,transaction_total_usd REAL,record_origin TEXT);
CREATE TABLE transaction_lines(transaction_id INTEGER,line_number INTEGER,product_id INTEGER,quantity INTEGER,unit_price_paid_usd REAL,unit_cost_usd REAL,record_origin TEXT,PRIMARY KEY(transaction_id,line_number));
CREATE TABLE monthly_inventory(store_id INTEGER,product_id INTEGER,month TEXT,opening_units INTEGER,received_units INTEGER,sold_units INTEGER,closing_units INTEGER,stockout_days INTEGER,record_origin TEXT,PRIMARY KEY(store_id,product_id,month));
CREATE TABLE daily_store_traffic(store_id INTEGER,date TEXT,visits INTEGER,record_origin TEXT,PRIMARY KEY(store_id,date));
CREATE TABLE campaign_costs(promotion_id INTEGER,store_id INTEGER,cost_usd REAL,record_origin TEXT,PRIMARY KEY(promotion_id,store_id));
''')
c.executemany('INSERT INTO original_promotion_observations(store_id,location,store_size_sqft,store_type,promotion_id,promotion_type,start_date,end_date,weekly_sales_during,weekly_sales_before,weekly_sales_after,avg_daily_visits_during,avg_daily_visits_before,avg_daily_visits_after) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',original)
state_by_city={'New York':'NY','Los Angeles':'CA','Chicago':'IL','Houston':'TX','Phoenix':'AZ','Philadelphia':'PA','San Antonio':'TX','San Diego':'CA','Dallas':'TX','San Jose':'CA','Austin':'TX','Jacksonville':'FL','Fort Worth':'TX','Columbus':'OH','Indianapolis':'IN','Charlotte':'NC','Seattle':'WA','Denver':'CO','Washington':'DC','Nashville':'TN','Oklahoma City':'OK','El Paso':'TX','Detroit':'MI','Boston':'MA','Portland':'OR','Las Vegas':'NV','Miami':'FL','Atlanta':'GA','Minneapolis':'MN','Tampa':'FL','Orlando':'FL','Cleveland':'OH','Pittsburgh':'PA','Sacramento':'CA','Raleigh':'NC','Salt Lake City':'UT','Kansas City':'MO','St Louis':'MO','Baltimore':'MD','San Francisco':'CA'}
region_map={'CA':'West','WA':'West','OR':'West','NV':'West','AZ':'West','UT':'West','CO':'West','NY':'Northeast','MA':'Northeast','PA':'Northeast','DC':'Northeast','MD':'Northeast','OH':'Midwest','IL':'Midwest','MN':'Midwest','MI':'Midwest','IN':'Midwest','MO':'Midwest','TX':'South','FL':'South','GA':'South','NC':'South','TN':'South','OK':'South'}
original_cities=[x[1] for x in original];cities=list(state_by_city)
stores=[]
for i in range(1,151):
 if i<=25:
  r=original[i-1];city,size,typ=r[1],r[2],r[3];city=city if city in state_by_city else R.choice(cities)
 else:
  city=R.choice(cities);typ=R.choices(['Urban','Suburban','Rural'],[.45,.45,.10])[0];size=R.randrange(1100,4201,100)
 state=state_by_city[city];stores.append((i,city,state,region_map[state],typ,size,'2022-01-01' if i<=25 else '2023-07-01',int(i<=25),'ORIGINAL_STORE_ATTRIBUTES' if i<=25 else 'SYNTHETIC'))
c.executemany('INSERT INTO stores VALUES (?,?,?,?,?,?,?,?,?)',stores)
category_items={'Apparel':['Hiking Jacket','Trail Pants','Fleece Pullover','Merino Base Layer','Rain Shell','Sun Shirt','Performance Socks','Thermal Gloves','Trail Cap','Insulated Vest'], 'Footwear':['Hiking Boots','Trail Runners','Trekking Sandals','Waterproof Boots','Camp Slippers','Approach Shoes','Winter Boots','Running Shoes','Climbing Shoes','Hiking Socks'], 'Camping':['Tent','Sleeping Bag','Sleeping Pad','Camp Stove','Headlamp','Camping Chair','Lantern','Cookware Kit','Water Filter','Dry Bag'], 'Equipment':['Backpack','Trekking Poles','Compass','Hydration Pack','GPS Device','Climbing Rope','Portable Charger','Binoculars','First Aid Kit','Multi-tool'], 'Accessories':['Reusable Water Bottle','Travel Mug','Sunglasses','Beanie','Backpack Rain Cover','Insect Repellent','Map Case','Carabiner','Neck Gaiter','Repair Kit']}
products=[]
for i in range(1,121):
 cat= list(category_items)[(i-1)%5];name=category_items[cat][((i-1)//5)%10];variant=['Classic','Eco','Premium'][(i//7)%3]; sustainable=int('Eco' in variant or R.random()<.40)
 price=round(R.uniform(18,95) if cat in ('Accessories','Apparel') else R.uniform(40,260),2);cost=round(price*R.uniform(.39,.69),2)
 products.append((i,f'GT-{i:04d}',f'{name} {variant} {i:03d}',cat,price,cost,sustainable,R.randint(70,98) if sustainable else R.randint(24,70),'SYNTHETIC'))
c.executemany('INSERT INTO products VALUES (?,?,?,?,?,?,?,?,?)',products)
segments=[(1,'Value Seekers','Price-conscious occasional shoppers','SYNTHETIC'),(2,'Outdoor Enthusiasts','Frequent outdoor and adventure shoppers','SYNTHETIC'),(3,'Eco-Conscious','Prefers sustainable products','SYNTHETIC'),(4,'Family Shoppers','Household and group purchases','SYNTHETIC'),(5,'Casual Shoppers','Low frequency casual shoppers','SYNTHETIC')]
c.executemany('INSERT INTO customer_segments VALUES (?,?,?,?)',segments)
start=dt.date(2024,1,1);end=dt.date(2025,12,31);days=(end-start).days+1
promotion_types=['Discount','Buy-One-Get-One','Special Event','Loyalty Reward','Sustainability Spotlight']
promotions=[]; assignments=[];costs=[];promo_by_store=collections.defaultdict(list)
# 650 localized campaigns (one store per campaign, matched controls; control assignment is synthetic observational model only)
for j in range(650):
 pid=10001+j; sid=1+(j*61+R.randrange(150))%150;date=start+dt.timedelta(days=R.randint(0,days-21));duration=R.choice([7,10,14]);last=date+dt.timedelta(days=duration-1)
 kind=promotion_types[j%5];rate=round(R.uniform(.08,.30),3) if kind=='Discount' else .0
 budget=round(R.uniform(500,3300),2)
 promotions.append((pid,kind,date.isoformat(),last.isoformat(),rate,budget,'Improve profitable sales and customer engagement','SYNTHETIC'))
 assignments.append((pid,sid,'TEST','SIMULATED_MATCHING_NOT_RANDOMIZED','SYNTHETIC'))
 # comparable geographic/size control chosen non-treated for this campaign
 available=[s for s in stores if s[0]!=sid and s[3]==stores[sid-1][3] and abs(s[5]-stores[sid-1][5])<=1200]
 if not available:available=[s for s in stores if s[0]!=sid and s[3]==stores[sid-1][3]]
 control=R.choice(available)[0];assignments.append((pid,control,'CONTROL','SIMULATED_MATCHING_NOT_RANDOMIZED','SYNTHETIC'))
 costs.append((pid,sid,budget,'SYNTHETIC'))
 promo_by_store[sid].append((date,last,pid,kind,rate))
c.executemany('INSERT INTO promotions VALUES (?,?,?,?,?,?,?,?)',promotions)
c.executemany('INSERT INTO store_promotion_assignments VALUES (?,?,?,?,?)',assignments)
c.executemany('INSERT INTO campaign_costs VALUES (?,?,?,?)',costs)
# use baseline 100-160k transactions, ~3-5 per store per day on average; sparse realistic SAMPLE of store transactions, not complete POS ledger
transactions=[];lines=[];traffic=[]; sold_month=collections.Counter();transaction_id=1
prices={p[0]:(p[4],p[5]) for p in products}
for sid,city,state,region,typ,sz,_,_,_ in stores:
 promos=promo_by_store[sid];store_factor=sz/2300
 for offset in range(days):
  date=start+dt.timedelta(days=offset);dow=date.weekday();winter=date.month in (11,12);weekend=dow>=5
  active=[p for p in promos if p[0]<=date<=p[1]]
  # sampled POS dataset (not representative of all sales)
  expected=3.1*store_factor*(1.28 if weekend else 1)*(1.24 if winter else 1)*(1.18 if active else 1)
  n=max(0,int(expected+R.gauss(0,math.sqrt(expected))+.5))
  visits=max(n+1,int(R.gauss(35*store_factor*(1.15 if weekend else 1)*(1.12 if active else 1),6)))
  traffic.append((sid,date.isoformat(),visits,'SYNTHETIC'))
  for _ in range(n):
   p=R.choice(active) if active and R.random()<.70 else None
   promo_id=p[2] if p else None;kind=p[3] if p else None;discount=p[4] if p else 0
   segment=R.choices([1,2,3,4,5],[.25,.23,.18,.18,.16])[0]
   numlines=R.choices([1,2,3,4],[.57,.29,.11,.03])[0]
   total=0
   for line_no in range(1,numlines+1):
    product=R.randrange(1,121);qty=R.choices([1,2,3],[.86,.12,.02])[0];price,cost=prices[product]
    if kind=='Discount':paid=round(price*(1-discount),2)
    elif kind=='Buy-One-Get-One' and qty>=2:paid=round(price*.5,2)
    elif kind=='Loyalty Reward' and segment==2:paid=round(price*.9,2)
    else:paid=price
    total+=paid*qty
    lines.append((transaction_id,line_no,product,qty,paid,cost,'SYNTHETIC'))
    sold_month[(sid,product,date.strftime('%Y-%m'))]+=qty
   transactions.append((transaction_id,sid,date.isoformat(),segment,promo_id,round(total,2),'SYNTHETIC'));transaction_id+=1
  if offset%92==0 and sid%25==0:pass
c.executemany('INSERT INTO transactions VALUES (?,?,?,?,?,?,?)',transactions)
c.executemany('INSERT INTO transaction_lines VALUES (?,?,?,?,?,?,?)',lines)
c.executemany('INSERT INTO daily_store_traffic VALUES (?,?,?,?)',traffic)
# inventory simulated as stock ledger consistent at monthly level with GENERATED transaction sample; not store-wide stock activity.
inventory=[]
for sid in range(1,151):
 for product in range(1,121):
  opening=R.randint(6,38)
  for year in (2024,2025):
   for month in range(1,13):
    ym=f'{year}-{month:02d}';sold=sold_month[(sid,product,ym)]
    restock=max(0,15-opening)+R.randint(0,12)+sold
    closing=opening+restock-sold
    inventory.append((sid,product,ym,opening,restock,sold,closing,0 if closing>4 else R.randint(0,3),'SYNTHETIC'))
    opening=closing
c.executemany('INSERT INTO monthly_inventory VALUES (?,?,?,?,?,?,?,?,?)',inventory)
c.executescript('''CREATE INDEX idx_tx_store_date ON transactions(store_id,transaction_date);CREATE INDEX idx_tx_promo ON transactions(promotion_id);CREATE INDEX idx_lines_product ON transaction_lines(product_id);CREATE INDEX idx_assignment_store ON store_promotion_assignments(store_id);CREATE INDEX idx_inventory_month ON monthly_inventory(month);''');conn.commit()
tables=['original_promotion_observations','stores','products','customer_segments','promotions','store_promotion_assignments','transactions','transaction_lines','monthly_inventory','daily_store_traffic','campaign_costs']
for table in tables:
 cols=[r[1] for r in c.execute(f'PRAGMA table_info({table})')];p=BASE/f'{table}.csv'
 with p.open('w',newline='',encoding='utf-8') as f:
  wr=csv.writer(f);wr.writerow(cols)
  for row in c.execute(f'SELECT * FROM {table}'):wr.writerow(row)
counts={t:c.execute(f'SELECT COUNT(*) FROM {t}').fetchone()[0] for t in tables}
(BASE/'data_dictionary.csv').write_text('table,column,type,description\n',encoding='utf-8')
with (BASE/'data_dictionary.csv').open('a',newline='',encoding='utf-8') as f:
 w=csv.writer(f)
 for table in tables:
  for row in c.execute(f'PRAGMA table_info({table})'):
   desc=('Provenance label: ORIGINAL_UPLOADED, ORIGINAL_STORE_ATTRIBUTES or SYNTHETIC' if row[1]=='record_origin' else 'Synthetic field unless original observation table or original store attributes; refer to README for assumptions')
   w.writerow([table,row[1],row[2],desc])
readme=f'''# GreenTrail Outdoors — expanded retail analytics portfolio dataset

**Status: SYNTHETIC EDUCATIONAL DATASET, NOT REAL RETAIL PERFORMANCE DATA**  
Built from the provided 25-row GreenTrail exercise spreadsheet, and expanded using a reproducible simulation (fixed seed `20261014`). Do not present simulated results as actual Mastercard or GreenTrail business outcomes.

## Scope
- 150 stores (the first 25 preserve the original store ID, city/location, size and type when available); 125 additional entirely synthetic stores.
- 24 complete months: **2024-01-01 to 2025-12-31** for all generated event tables.
- 650 synthetic localized promotional campaigns, each with 1 test and 1 matched control store assignment. This is **not** a true randomized controlled trial. Control assignments can overlap other campaigns and are for practicing matching/experimental design, not validated causal inference.
- A **sample of simulated POS transactions**, not the entirety of store financial sales. Generated revenue cannot be reconciled to the uploaded weekly-sales summary because those source observations are for different historical dates and are not transaction-level records.
- 120 synthetic products; 5 invented customer segments; daily store visits; monthly simulated inventory; and campaign cost estimates.
- Values in **US dollars** for synthetic transaction revenue/pricing/budgets (source spreadsheet currency unspecified).

## Exact original preservation
- `source/GreenTrail Store Data.xlsx` is a byte-for-byte copy of the uploaded workbook.
- `original_promotion_observations.csv` is a normalized copy of **all 25 original records**, including their actual Excel dates converted to ISO dates (and all numeric values preserved).
- `stores.csv` incorporates the original **store IDs, locations, sizes and types** into the first 25 records. Additional attributes such as state and region are inferred/simulated mappings and **are not source data**.
- Source promotions have IDs 101–125 and their actual source dates. New campaigns have separate IDs 10001–10650 and do not claim to extend the original campaigns.

## Table sizes
{chr(10).join('- '+t+': '+format(n,',')+' records' for t,n in counts.items())}

## Relationships
- stores.store_id → transactions.store_id, daily_store_traffic.store_id, monthly_inventory.store_id, store_promotion_assignments.store_id, campaign_costs.store_id
- transactions.transaction_id → transaction_lines.transaction_id
- products.product_id → transaction_lines.product_id, monthly_inventory.product_id
- promotions.promotion_id → transactions.promotion_id (nullable), store_promotion_assignments.promotion_id, campaign_costs.promotion_id
- customer_segments.segment_id → transactions.segment_id
- original_promotion_observations is **historical source reference**, not a fact table to join by promotion_id to synthetic campaigns.

## Important limitations
1. Transactions are synthetic and sampled, and the provided 25 records do **not** support validating simulated campaign impacts, retention, demand or ROI.
2. For BOGO, synthetic line-level paid price models 50% off qualifying multi-unit lines; it is a simplified practice model, not true every-second-item discount logic.
3. Inventory sold_units equals generated transaction-line unit counts, not full-store sales. Simulated received_units are engineered to keep closing stocks nonnegative; stockout_days are illustrative and not actual demand-censored observations.
4. Daily visits are simulated independently of the provided original pre/during/post visit figures; generated conversion rates are illustrative.
5. Campaign budget and costs are assumed, not observed. A test/control comparison should explicitly check overlapping campaigns and pre-period balance before interpretation.
6. Dates from original 2023 promotions are **not** fabricated into the 2024–2025 generated timeline.

## Contents
- `greentrail_retail.sqlite`: ready-to-query relational database (SQLite).
- `*.csv`: one extract per entity/fact table; usable with Power BI, SQL, Python or Excel.
- `data_dictionary.csv`: table columns and provenance notes.
- `starter_queries.sql`: practice queries for SQL portfolio.
- `source/GreenTrail Store Data.xlsx`: untouched original attachment.
- `generation_script.py`: reproducible generator (requires Python stdlib only and the original workbook).

## Suggested portfolio caption
> Independent case study using 25 provided training observations and a transparently generated, 150-store, 24-month synthetic retail dataset. Analyses and dashboards demonstrate methodology and do not represent actual client results.
'''
(BASE/'README.md').write_text(readme)
(BASE/'starter_queries.sql').write_text('''-- All figures below refer to SYNTHETIC simulated data except query 1.
-- 1. Preserved historical original observation, by promotion type
SELECT promotion_type, COUNT(*) AS stores, ROUND(AVG((weekly_sales_during-weekly_sales_before)*100.0/NULLIF(weekly_sales_before,0)),2) AS mean_percent_change
FROM original_promotion_observations GROUP BY promotion_type ORDER BY mean_percent_change DESC;

-- 2. Monthly sampled POS revenue and gross margin
SELECT substr(t.transaction_date,1,7) month,COUNT(DISTINCT t.transaction_id) transactions, ROUND(SUM(l.quantity*l.unit_price_paid_usd),2) revenue_usd, ROUND(SUM(l.quantity*(l.unit_price_paid_usd-l.unit_cost_usd)),2) gross_profit_usd
FROM transactions t JOIN transaction_lines l USING(transaction_id) GROUP BY 1 ORDER BY 1;

-- 3. Regional revenue and basket size
SELECT s.region,ROUND(SUM(t.transaction_total_usd),2) sample_revenue_usd,ROUND(AVG(t.transaction_total_usd),2) avg_basket_usd
FROM transactions t JOIN stores s USING(store_id) GROUP BY 1 ORDER BY 2 DESC;

-- 4. Revenue and margin from transactions tagged to promotion (DESCRIPTIVE, NOT INCREMENTAL ROI)
SELECT p.promotion_type,COUNT(DISTINCT t.transaction_id) tagged_transactions,ROUND(SUM(l.quantity*l.unit_price_paid_usd),2) tagged_revenue_usd,ROUND(SUM(l.quantity*(l.unit_price_paid_usd-l.unit_cost_usd)),2) tagged_gross_profit_usd
FROM transactions t JOIN promotions p ON t.promotion_id=p.promotion_id JOIN transaction_lines l USING(transaction_id)
GROUP BY 1;

-- 5. Monthly product movement / inventory integrity check
SELECT COUNT(*) AS invalid_inventory_rows FROM monthly_inventory WHERE opening_units+received_units-sold_units <> closing_units OR closing_units<0;
''')
conn.close();(BASE/'source').mkdir(exist_ok=True);shutil.copy2(SRC,BASE/'source'/'GreenTrail Store Data.xlsx');shutil.copy2('/mnt/data/build_greentrail_dataset.py',BASE/'generation_script.py')
archive='/mnt/data/GreenTrail_Expanded_Dataset_Option_C.zip'
with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as output:
 for path in BASE.rglob('*'):
  if path.is_file():output.write(path,path.relative_to(BASE.parent))
print(json.dumps({'counts':counts,'zip_bytes':os.stat(archive).st_size,'sqlite_bytes':(BASE/'greentrail_retail.sqlite').stat().st_size},indent=2))
