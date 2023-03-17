DROP CONSTRAINT ON (list:LISTINGS) ASSERT list.listing_id IS UNIQUE 
DROP CONSTRAINT ON (host:HOST) ASSERT host.host_id IS UNIQUE
DROP CONSTRAINT ON (user:USER) ASSERT user.user_id IS UNIQUE
DROP CONSTRAINT ON (review:REVIEW) ASSERT review.review_id IS UNIQUE



//CREATING A UNIQUENESS CONSTRAINT ON LISTINGS ID
CREATE CONSTRAINT ON (list:LISTINGS) ASSERT list.listing_id IS UNIQUE
// INDEX IS AUTOMATICALLY CREATED BY CONSTRAINT DEFINED ABOVE
CREATE CONSTRAINT ON (host:HOST) ASSERT host.host_id IS UNIQUE

//INITIALLY SET THE LISTING ID AS UNIQUE
LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
WITH DISTINCT row.id AS listing_id
MERGE (list:LISTINGS {listing_id: toInteger(listing_id)})

//INITIALLY SET THE HOST ID AS UNIQUE 
LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
WITH DISTINCT row.host_id AS host_id
MERGE (host:HOST {host_id: toInteger(host_id)})

//NOW ADDING ADDITIONAL PROPERTIES
LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
MATCH (list:LISTINGS {listing_id : toInteger(row.id)})
SET list.listing_url = row.listing_url,
	list.scrape_id = toInteger(row.scrape_id),
	list.name = row.name,
    list.summary = row.summary,
    list.space = row.space,
	list.neighbourhood = row.neighbourhood,
	list.host_id = toInteger(row.host_id)

//ADDING ADDITIONAL PROPERTIES ON THE HOST NODE
	
LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
MATCH (host:HOST {host_id: toInteger(row.host_id)})
SET host.host_url = row.host_url,
    host.host_name = row.host_name,
    host.host_since = row.host_since,
    host.host_location = row.host_location	

//ADD EDGES BETWEEN HOST AND LISTINGS 
MATCH (list:LISTINGS), (host:HOST)
WHERE list.host_id = host.host_id
CREATE (host)-[:OWNS]->(list)	

//LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
//MATCH (list:LISTINGS {listing_id : toInteger(row.id)})
//WHERE list.listing_id = h.host_listing_id

//CREATE (host:HOST)
//SET host.host_id = toInteger(row.host_id),
//	host.host_url = row.host_url,
//   host.host_name = row.host_name,
//   host.host_since = row.host_since,
//   host.host_location = row.host_location

//CREATE HOST-HOST KNOWS RELATIONSHIP
MATCH (h:HOST)	
WITH collect(h) as hosts
UNWIND range(0, size(hosts) - 1) as pos
SET (hosts[pos]).number = pos

//ASSIGN A FRIEND_ID TO EACH HOST NODE RANDOMLY

MATCH (h:HOST)	
SET h.friend_id = toInteger(rand()*h.number)


//CREATE HOST-KNOWS RELATIONSHIPS 
MATCH (row:HOST)
WITH row.user_name as name, toInteger(row.number) as usrid, toInteger(row.friend_id) as friendid
WHERE usrid <> friendid
WITH name as user_name, usrid as user_id ,friendid as friend_id
MATCH (user:HOST {number : user_id}), (friend:HOST { number: friend_id})
CREATE (user)-[:KNOWS]->(friend)


//CREATE A USER FROM ReviewMock2 DATASET
CREATE CONSTRAINT ON (user:USER) ASSERT user.user_id IS UNIQUE


//CREATE USER NODES WITH ONLY REVIEWER ID AND REVIEWER NAME
LOAD CSV WITH HEADERS FROM "file:///reviews.csv" AS row
WITH DISTINCT row.reviewer_id AS user_id, row.reviewer_name AS user_name
MERGE (user:USER {user_id : toInteger(user_id), user_name : user_name})



//ASSIGN a ROW_NUMBER() TO EACH NODE IN CYPHER
MATCH (u:USER)	
WITH collect(u) as users
UNWIND range(0, size(users) - 1) as pos
SET (users[pos]).number = pos
	
//ASSIGN A FRIEND_ID TO EACH USER NODE RANDOMLY

MATCH (u:USER)	
SET u.friend_id = toInteger(rand()*u.number)


//CREATE USER-FRIEND RELATIONSHIPS 
MATCH (row:USER)
WITH row.user_name as name, toInteger(row.number) as usrid, toInteger(row.friend_id) as friendid
WHERE usrid <> friendid
WITH name as user_name, usrid as user_id ,friendid as friend_id
MATCH (user:USER {number : user_id}), (friend:USER { number: friend_id})
CREATE (user)-[:FRIENDS_WITH]->(friend)


//CREATE CONSTRAINTS ON REVIEW
CREATE CONSTRAINT ON (review:REVIEW) ASSERT review.review_id IS UNIQUE

//CREATE REVIEW NODE 
LOAD CSV WITH HEADERS FROM "file:///reviews.csv" AS row
WITH DISTINCT toInteger(row.id) AS review_id
MERGE (review:REVIEW {review_id : toInteger(review_id)})


//SET PROPERTIES ON THE USER FROM REVIEWER DATASET 
//LOAD CSV WITH HEADERS FROM "file:///reviews.csv" AS row
//MATCH (user:USER {user_id: toInteger(row.reviewer_id)})

//CREATE REVIEW NODES SET PROPERTIES AND CONNECT WITH USERS WITH A WROTE RELATIONSHIP
LOAD CSV WITH HEADERS FROM "file:///reviews.csv" AS row
MATCH (review:REVIEW {review_id: toInteger(row.id)})
SET review.user_comments = row.comments,
    review.listing_id = toInteger(row.listing_id),
    review.user_id = toInteger(row.reviewer_id),
	review.review_date = row.date 

//CREATE (review:REVIEW)
//SET review.review_id = toInteger(row.id),
//    review.user_comments = row.comments,
//    review.listing_id = toInteger(row.listing_id) 
//CREATE (user)-[:WROTE {date : row.date}]->(review)

//CREATE THE REVIEW AND USERS RELATIONSHIP 

MATCH (u:USER), (r:REVIEW)
WHERE u.user_id = r.user_id
CREATE (u)-[:WROTE]->(r)

//CREATE THE REVIEW AND LISTING RELATIONSHIP 

MATCH (review:REVIEW), (listing:LISTINGS)
WHERE review.listing_id = listing.listing_id
CREATE (review)-[:REVIEWS_FOR]->(listing)




//CALENDAR DETAILS CREATE CALENDAR NODES 
LOAD CSV WITH HEADERS FROM "file:///calendar.csv" AS row
CREATE (cal:CALENDAR)
SET cal.listing_id = toInteger(row.listing_id),
	cal.date = row.date,
    cal.available = row.available,
    cal.price = toFloat(row.price)
	

//CREATE RELATIONSHIPS BETWEEN LISTINGS AND CALENDAR
MATCH (list:LISTINGS), (cal:CALENDAR)
WHERE list.listing_id = cal.listing_id
CREATE (list)-[:HAS]->(cal)	

//LIST BOOKING DETAILS

//LOAD CSV WITH HEADERS FROM "file:///calendar.csv" AS row
//MATCH (list:LISTINGS {listing_id: toInteger(row.listing_id)})
//
//CREATE (bookD:BOOKING_DETAILS)
//SET bookD.listing_id = toInteger(row.listing_id),
//	bookD.available_date = row.date,
//    bookD.isAvailable = row.available,
//    bookD.price = row.price  
//CREATE (list)-[:IS_AVAILABLE {available_date:row.date, listing_id:toInteger(row.listing_id)}]->(bookD)

//CREATE AMENITIES NODES

LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
WITH DISTINCT toInteger(row.id) AS listing_id
MERGE (amen:AMENITY {listing_id : toInteger(listing_id)})

//LOAD CSV WITH HEADERS FROM "file:///listings.csv" AS row
//MATCH (list:LISTINGS {listing_id : toInteger(row.id)})
//WHERE list.listing_id = h.host_listing_id

//SETTING PROPERTIES ON THE AMENITY NODES
MATCH (amen:AMENITY)
SET amen.property_type = row.property_type,
	amen.room_type = row.room_type,
    amen.accomodates = toInteger(row.accomodates),
    amen.bathrooms = toFloat(row.bathrooms),
    amen.bedrooms = toInteger(row.bedrooms),
    amen.beds = toInteger(row.beds),
    amen.bed_type = row.bed_type,
    amen.amenities = row.amenities,
    amen.price = toFloat(row.price),
    amen.weekly_price = toFloat(row.weekly_price), 
    amen.security_deposit = toFloat(row.security_deposit),
    amen.cleaning_fee = toFloat(row.cleaning_fee)
	
//CREATE RELATIONSHIP BETWEEN LISTINGS AND AMENITY 	
MATCH (list:LISTINGS), (amen:AMENITY)
WHERE list.listing_id = amen.listing_id
CREATE (list)-[:HAS]->(amen)
//CREATE A NEW RELATIONSHIP KNOWS BETWEEN HOST AND USER. 
//SINCE THEY HAVE LIVED IN THE PROPERTY AND SPENT SOME TIME WITH THE HOST SO IT CAN BE ASSUMED THAT THEY KNOW THEM

MATCH (user:USER)-[w:WROTE]->(review:REVIEW)-[:REVIEWS_FOR]->(listing:LISTINGS)<-[:OWNS]-(host:HOST)
CREATE (user)-[:KNOWS {since:w.date}]->(host)




//----------------------------------------------------------------------------------------------
//*************************************************SCRIBBLE SCRIPT*****************************
//**********************************************************************************************
//**********************************************************************************************
//**********************************************************************************************
//**********************************************************************************************
//AN EXAMPLE OF PIPELINE QUERIES WITH CLAUSE IN CYPHER
//MATCH (user:USER {number : toInteger(row.user_id)}), (friend:USER {number: row.friend_id}) this particular line 
//of query will not return any result set because i m comparing an integer with string (row.friend_id have to cast a toInteger function)

LOAD CSV WITH HEADERS FROM "file:///export.csv" AS row
WITH row.user_name as name, toInteger(row.user_id) as usrid, toInteger(row.friend_id) as friendid
WHERE usrid <> friendid
WITH name as user_name, usrid as user_id ,friendid as friend_id
MATCH (user:USER {number : user_id}), (friend:USER { number: friend_id})
RETURN user.user_name, user.number, friend.user_name, friend.number


//CODE TO ASSIGN RANDOM FRIEND_ID TO THE USER IN ORDER TO CREATE A FREIND RELATIONSHIP
MATCH (u:USER)	
RETURN toString(u.user_name) AS user_name, toInteger(u.number) AS user_id, toInteger(u.friend_id) AS friend_id

//SOME SAMPLE QUERIES

LOAD CSV WITH HEADERS FROM "file:///ReviewMock2.csv" AS row
WITH row.reviewer_id as id, COUNT(row.reviewer_id) as Cnt
WHERE Cnt > 1
RETURN id

//TEST QUERIES FOR CREATING A USER
LOAD CSV WITH HEADERS FROM "file:///ReviewMock2.csv" AS row
WITH  row.reviewer_id AS id, COUNT(row.reviewer_id) AS cnt
WHERE cnt > 1
RETURN id, cnt


///QUERIES WRITTEN FOR CORRECTING THE TRANSFORMATION SCRIPTS 

LOAD CSV WITH HEADERS FROM "file:///reviews.csv" AS row
WITH toInteger(row.reviewer_id) AS rid, row.reviewer_name AS name
WITH rid as r,name as n, count(*) as cnt
WHERE cnt = 2
RETURN r,n ,cnt





