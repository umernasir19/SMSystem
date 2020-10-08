create table planner(
ID int primary key identity(1,1),
TO_DO nvarchar(100) not null,
TO_DO_Date datetime not null,
DateCreated datetime not null,
CreatedBy int not null,
status bit,
)