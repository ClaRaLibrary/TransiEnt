within TransiEnt.Basics.Types;
type Poolsize
      extends Integer;
            annotation(choices(choice=1 "N=1", choice=20 "N=20",choice=100 "N=100"));
end Poolsize;
