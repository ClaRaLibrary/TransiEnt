within TransiEnt.Basics.Types;
type HotWaterProfile
      extends Integer;
      annotation(choices(choice=HotWaterProfile_onePerson     "One person appartment",
      choice=HotWaterProfile_threePerson     "Three person appartment (without bath)",
       choice=HotWaterProfile_threePersonBath     "Three person appartment with bath"));
end HotWaterProfile;
