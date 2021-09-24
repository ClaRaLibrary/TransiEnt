within TransiEnt.Basics.Types;
type TypeOfWeekday =
             Integer(min=0,max=7) "Type for defining weekdays or weekends"
   annotation(choices(
                choice=2 "Monday",
                choice=3 "Tuesday",
                choice=4 "Wednesday",
                choice=5 "Thursday",
                choice=6 "Friday",
                choice=0 "Saturday",
                choice=1 "Sunday"));
