/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */

/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select name,membercost from facilities where membercost > 0;


/* Q2: How many facilities do not charge a fee to members? */
select count(*) from facilities where membercost =0;


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select facid,name,membercost,monthlymaintenance from facilities where membercost < (0.2*monthlymaintenance);
/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

select * from facilities where facid in(1,5);
/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select name,monthlymaintenance ,CASE  when monthlymaintenance > 100 then 'expensive' else 'cheap' end as typeOfMaintenance from facilities ;
/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */


select * from members where joindate in(select max(joindate) from members);

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select concat(f.name,m.firstname) as facilitiesAndMembers ,b.bookid from bookings b ,facilities f, members m where b.facid in(select facid from facilities where name like 'Tennis %') and f.facid = b.facid and b.memid = m.memid order by m.firstname;

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select concat(f.name,m.firstname) as FaciltiesandCustomerdetails, CASE
    WHEN b.memid = 0 THEN  b.slots * f.guestcost else b.slots * f.membercost
    END AS cost  from bookings b,facilities f,members m where starttime like '2012-09-14%' and b.facid = f.facid and b.memid = m.memid 
    and case when b.memid = 0 THEN  b.slots * f.guestcost >30 else b.slots * f.membercost >30 end order by cost desc;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT *
  FROM ( 
	select concat(f.name,m.firstname) as FaciltiesandCustomerdetails, CASE
	WHEN b.memid = 0 THEN  b.slots * f.guestcost else b.slots * f.membercost
	END AS cost  from bookings b,facilities f,members m where starttime like '2012-09-14%' 
	and b.facid = f.facid and b.memid = m.memid order by cost desc )
	sub where sub.cost >30;
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT name,
	   total_revenue
	FROM (SELECT name ,SUM(cost) AS total_revenue 
			FROM   (SELECT name,
	   		    	   	   case WHEN b.memid = 0 THEN  b.slots * f.guestcost else b.slots * f.membercost END AS cost
						FROM Bookings b,facilities f where b.facid = f.facid
    					ORDER BY cost DESC)   as sub
			GROUP BY name)as sub_cost
	WHERE total_revenue<1000
	ORDER BY total_revenue ;