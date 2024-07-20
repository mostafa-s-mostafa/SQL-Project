/******************* In the Library *********************/

/*******************************************************/
/* find the number of availalbe copies of the book (Dracula)      */
/*******************************************************/
SELECT b.BookID, b.Title
FROM loans AS l
LEFT JOIN books AS b ON b.BookID = l.bookID
WHERE b.Title = 'Dracula' AND b.BookID != (
select b.BookID from loans as l
inner join books as b on b.BookID = l.BookID
where Title = 'Dracula' and ReturnedDate is null
)
GROUP BY b.BookID;

/* check total copies of the book */

select Title, count(BookID) as numbers_0f_copies from books
where Title = 'Dracula';


/* current total loans of the book */

SELECT b.Title, count(*) FROM loans AS l
inner JOIN books AS b ON b.BookID = l.BookID
WHERE l.ReturnedDate IS NULL AND b.title = 'Dracula';


/* total available books of dracula */

SELECT b.BookID, COUNT(l.LoanID) AS loaned_count
FROM loans AS l
LEFT JOIN books AS b ON b.BookID = l.bookID
WHERE b.Title = 'Dracula' AND b.BookID != (
select b.BookID from loans as l
inner join books as b on b.BookID = l.BookID
where Title = 'Dracula' and ReturnedDate is null
)
GROUP BY b.BookID;

/*******************************************************/
/* Add new books to the library                        */
/*******************************************************/
insert into books (bookid, title, author, published, barcode) values (201,'de7k', 'adel', 2019, 2482001);
insert into books (bookid, title, author, published, barcode) values (202,'PYTHON', 'mostafa saad', 2000, 1552000);

insert into books (bookid, title, author, published, barcode) values
(203, 'journey to the center of the earth', 'Ahmed Ayman', 1999, 2060708),
(204, 'once upon time','abdelziz', 1998, 45658978),
(205, 'venom', 'marvel', 1888, 10397850);
select * from books
where BookID in (201, 202, 203, 204, 205, 206);

/*******************************************************/
/* Check out Books: books(4043822646, 2855934983) whose patron_email(jvaan@wisdompets.com), loandate=2020-08-25, duedate=2020-09-08, loanid=by_your_choice                            */
/*******************************************************/
insert into loans (LoanID, BookID, PatronID, LoanDate, DueDate) values
(5000,
(select BookID from books where Barcode = 2855934983),
(select PatronID from patrons where email = 'jvaan@wisdompets.com'),
'2020-08-25','2020-09-08'),
(5001,
(select BookID from books where Barcode = 4043822646),
(select PatronID from patrons where email = 'jvaan@wisdompets.com'),
'2020-08-25','2020-09-08');

select * from loans
where LoanID in (5001,5000);

/********************************************************/
/* Check books for Due back                             */
/* generate a report of books due back on July 13, 2020 */
/* with patron contact information                      */
/********************************************************/
SELECT l.*, Title, p.* FROM loans AS l
LEFT JOIN books AS b ON b.BookID = l.BookID
inner join patrons as p on p.PatronID = l.PatronID
WHERE l.ReturnedDate IS NULL and l.DueDate = '2020-07-13';

/*******************************************************/
/* Return books to the library (which have barcode=6435968624) and return this book at this date(2020-07-05)                    */
/*******************************************************/
select * from loans
where LoanID = 1991;

UPDATE loans
SET returneddate = '2020-07-05'
WHERE bookID = (
SELECT bookID FROM books
WHERE barcode = '6435968624'AND returneddate IS NULL);


/*******************************************************/
/* Encourage Patrons to check out books                */
/* generate a report of showing 10 patrons who have
checked out the fewest books.                          */
/*******************************************************/
select p.PatronID, p.FirstName, p.Email, count(LoanID)as checke_out_num from books as b
inner join loans as l on l.BookID = b.BookID
inner join patrons as p on p.PatronID = l.PatronID
group by PatronID
order by checke_out_num	
limit 10;

/*******************************************************/
/* Find books to feature for an event                  
 create a list of books from 1890s that are
 currently available                                    */
/*******************************************************/
select b.title, count(b.BookID) as NumbersOfCopies from books as b
left join loans as l on l.BookID = b.BookID
where Published = 1890 and ReturnedDate is not null
group by b.title
order by NumbersOfCopies DESC;

/*******************************************************/
/* Book Statistics 
/* create a report to show how many books were 
published each year.                                    */
/*******************************************************/
SELECT Published, COUNT(DISTINCT(Title)) AS TotalNumberOfBooksPublished
FROM Books
GROUP BY Published
ORDER BY TotalNumberOfBooksPublished DESC;


/*************************************************************/
/* Book Statistics                                           */
/* create a report to show 5 most popular Books to check out */
/*************************************************************/
select b.title ,count(LoanID) as loan_count from books as b
inner join loans as l ON b.BookID = l.BookID
group by b.title
order by loan_count desc
limit 5;