create database if not exists NIIT;

use NIIT;

create table if not exists stu
(
rollno int primary key auto_increment,
stu_name varchar(20) not null,
gender char(2) default 'M',
tel char(11) unique
)engine=innodb;

insert into stu values
(1, 'Eason',null, '12345678912'),
(null, 'momo','F', '12345678913'),
(null, 'zixia','F', '12345678914'),
(null, 'bambam','F', '12345678915'),
(null, 'haoran','M', '12345678916');
insert into stu value(null, 'qianfa','F','12345678978');
select * from stu;

create table if not exists course
(
course_id int primary key auto_increment,
course_name varchar(20)
);

insert into course values
(1,'Java'),
(null,'MySQL'),
(null,'Html');
select * from course;

create table if not exists mark
(
mark_id int primary key auto_increment,
stu_id int,
course_id int,
score int,
constraint fk_couseid_course foreign key(course_id) references course(course_id),
constraint fk_stuid_course foreign key(stu_id) references stu(rollno)
);

insert into mark values
(1,1,2,100),
(null,1,3,99),
(null,2,1,90),
(null,2,3,95),
(null,3,1,92),
(null,3,2,97),
(null,4,1,100),
(null,4,3,100),(null,5,2,90),
(null,5,3,98);
select * from mark group by course_id;
truncate table mark;




select m.stu_id, s.stu_name, m.score from stu s, mark m where s.rollno = m.stu_id;

select rollno, stu_name, course_name, score from stu s left join mark m on(s.rollno=m.stu_id) 
left join course c on(c.course_id=m.course_id);

select s.rollno, s.stu_name 
from stu s where s.rollno in (select max(score) from mark m where s.rollno=m.stu_id);   ##not finished

select s.rollno, s.stu_name 
from stu s where s.rollno in (select stu_id from mark m1 where score in (select max(score) from mark m2));  ##not finished

select s.rollno, s.stu_name 
from stu s where s.rollno in (select stu_id from mark m1 where score in (select max(score) from mark m2 
group by m2.course_id));

delimiter //
create procedure us_average
(in studentID int,out scorelevel char(4)）
begin
declare @average int;
set scorelevel=null;
select @average=avg(score) from mark where stu_id=@studentID;

if(@average>=85) then
 set @scorelevel= '优秀';
else if(@average>=70 ) then
set @scorelevel= '良好';
else if(@average>=60) then
 set @scorelevel=  '一般';
else 
set @scorelevel= '不及格';
end if;
end
//


（2）
create function score_avg(@id int)  returns  @retValue Table (course_id  int, course_avg int)
begin
 
declare @c_id int;
declare @c_avg int;

set @c_id = @id;
set @c_avg = (select avg(score) from mark while course_id=@id);

insert into retValue(course_id,course_avg) values(@c_id,@c_avg);

return

end

（3）
create trigger delete_stu  on stu  after delete
as
if exists (select top 1 * from mark s inner join deleted d on s.stu_Id = d.rollno)
begin
rollback 
print ‘你必须先删除该学生的成绩才能删除该学生’
end
