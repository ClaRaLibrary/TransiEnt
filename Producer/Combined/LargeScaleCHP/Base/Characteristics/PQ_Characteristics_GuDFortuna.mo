within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics;
record PQ_Characteristics_GuDFortuna "Combined cycle unit based on 'GuD Fortuna', Source: Estimation made with stationary simulations of a power plant simulation program"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.Generic_PQ_Characteristics(
    final k_Q_flow=1,
    final k_P_el=1,
    PQboundaries=[
0,587.6e6,182e6;
148.884e6,559.6e6,150.5400784e6;
372.21e6,518.01e6,518e6],
  PQ_HeatInput_Matrix=[4e6,33e6,71e6,108e6,145e6,182e6,220e6,257e6,294e6,331e6,368e6;
160e6,416.242782900000e6,416.242782900000e6,416.242782900000e6,422.547331412500e6,426.385912620000e6,426.398328580000e6,426.398328580000e6,426.398328580000e6,426.398328580000e6,426.398328580000e6;
170e6,416.211541100000e6,419.270726113740e6,426.345358384849e6,432.963711100000e6,437.493865233333e6,440.206530041053e6,440.206530041053e6,440.206530041053e6,440.206530041053e6,440.206530041053e6;
180e6,421.209231320000e6,429.451410159542e6,436.542209594222e6,443.645879037920e6,448.194052122466e6,454.014731502105e6,454.014731502105e6,454.014731502105e6,454.014731502105e6,454.014731502105e6;
207e6,448.433225863987e6,459.310295511111e6,469.285369203618e6,478.931305754605e6,487.032812905263e6,493.879040875747e6,493.879040875747e6,493.879040875747e6,493.879040875747e6,493.879040875747e6;
232e6,481.318205652525e6,492.555521214646e6,503.944315584211e6,515.325670149708e6,524.511514956140e6,531.280467283333e6,532.376701292195e6,532.376701292195e6,532.376701292195e6,532.376701292195e6;
256e6,515.560124923810e6,527.606570716667e6,538.907375753216e6,550.215793621053e6,559.034048340936e6,567.780271798148e6,569.230068679158e6,569.230068679158e6,569.230068679158e6,569.230068679158e6;
276e6,543.463879001150e6,555.260329130952e6,567.070219926706e6,577.878480336257e6,587.017758062316e6,595.656954512000e6,599.268808234450e6,599.268808234450e6,599.268808234450e6,599.268808234450e6;
297e6,571.245995923810e6,583.607535338462e6,594.581831115400e6,604.927807799025e6,615.497958919298e6,624.610472726923e6,630.105939433732e6,629.748865842713e6,629.748865842713e6,629.748865842713e6;
317e6,598.017803167521e6,610.099942402469e6,620.667720497466e6,632.189314007490e6,642.140689575709e6,652.462942362667e6,659.104812890790e6,659.920928695834e6,659.920928695834e6,659.920928695834e6;
337e6,625.509847697436e6,636.499653809877e6,647.267563979757e6,659.757929178947e6,670.871364412632e6,680.891723080769e6,688.229571746737e6,690.526920334864e6,690.526920334864e6,690.526920334864e6;
356e6,651.327423034188e6,661.752902006173e6,673.553214195142e6,685.928852429555e6,696.884591621863e6,706.753413919231e6,715.125923460000e6,719.714920906263e6,719.714920906263e6,719.714920906263e6;
378e6,682.019755776068e6,691.555796666667e6,703.587505848381e6,715.547999643860e6,726.881293627530e6,737.014750157051e6,746.390244847368e6,752.607186389474e6,753.240401133333e6,753.240401133333e6;
400e6,711.969474387607e6,721.761879023077e6,732.619233157115e6,744.583946906680e6,756.822608486235e6,767.448286000000e6,777.168400892421e6,784.597174707018e6,786.417199179630e6,786.417199179630e6;
420e6,740.297322148889e6,749.096343663462e6,759.791851515789e6,772.394799812211e6,783.672072791498e6,795.147703850667e6,805.108420031579e6,813.669927134947e6,817.330904454717e6,817.330904454717e6;
441e6,769.476026869778e6,778.402880240000e6,788.947479390688e6,800.795483340688e6,812.951274692308e6,824.392269676923e6,834.702101238105e6,843.405449669263e6,850.122572712264e6,849.741069535849e6;
458e6,792.892188241026e6,802.156164916667e6,811.792871002227e6,823.708405379352e6,836.070834987449e6,847.627131419231e6,858.489159067409e6,867.732940560210e6,875.285963880921e6,876.287155329167e6;
476e6,817.290719077778e6,827.444859686667e6,837.226066848421e6,848.311694019028e6,860.546174594152e6,872.463935935897e6,883.432532444332e6,893.667754589474e6,901.759440431579e6,904.246187611765e6;
494e6,842.838842532445e6,852.887035443590e6,862.330883764372e6,873.161720450202e6,884.600295711741e6,897.402584197531e6,909.006343360122e6,919.542763658705e6,928.668443128000e6,932.341808837037e6;
507e6,861.164705255556e6,870.872352638462e6,880.347844364372e6,891.470046021053e6,903.039422727328e6,915.399746690124e6,927.695037949393e6,937.827421281633e6,947.077829308779e6,951.998433621795e6;
521e6,880.567733978633e6,890.478619245333e6,900.372501023482e6,910.852633487719e6,923.080225972125e6,934.608205212069e6,946.498854593502e6,957.066329920594e6,966.866370007252e6,968.424074085057e6;
531e6,894.547939359829e6,904.857844741026e6,914.749847638866e6,924.697364484211e6,936.434051608963e6,948.052463970690e6,959.869682472563e6,968.104069938889e6,968.193696193119e6,968.193696193119e6;
541e6,908.925375282906e6,919.235257433333e6,929.103901544156e6,938.543826269907e6,949.453466730229e6,961.482194716129e6,967.936019813303e6,967.936019813303e6,967.936019813303e6,967.936019813303e6;
551e6,923.302811912393e6,933.368961049123e6,942.848419742672e6,952.390949617570e6,962.472881851494e6,967.740002019277e6,967.740002019277e6,967.740002019277e6,967.740002019277e6,967.740002019277e6;
561e6,937.290272096863e6,947.050043189474e6,956.592937941187e6,966.238072965234e6,966.282892620690e6,966.282892620690e6,966.282892620690e6,966.282892620690e6,966.282892620690e6,966.282892620690e6;
571e6,951.051954916471e6,960.731125329825e6,967.006078101971e6,967.006078101971e6,967.006078101971e6,967.006078101971e6,967.006078101971e6,967.006078101971e6,967.006078101971e6,967.006078101971e6;
581e6,964.813637736079e6,966.221975137931e6,966.221975137931e6,966.221975137931e6,966.221975137931e6,966.221975137931e6,966.221975137931e6,966.221975137931e6,966.221975137931e6,966.221975137931e6]);
//min(372.21e6,Q_nom_condenser),(518.01e6-559.6e6)/(372.21e6-148.884e6)*(Q_nom_condenser-148.884e6)+559.6e6,(518e6-150.5400784e6)/(372.21e6-148.884e6)*(Q_nom_condenser-148.884e6)+150.5400784e6],
//372.21e6,518.01e6,518e6],
//min(372.21e6,Q_nom_condenser),(518e6-559.6e6)/(372.21e6-148.884e6)*(Q_nom_condenser-148.884e6)+559.6e6,(518e6-150.5400784e6)/(372.21e6-148.884e6)*(Q_nom_condenser-148.884e6)+150.5400784e6],

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for generic PQ characteristics of a combined cycle unit based on &apos;GuD Wedel&apos;</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>All records (PQ diagrams and Heat input matrixes) included in this package are included with the intention of illustrating the modelling concept.</p>
<p>However, users are encouraged to create their own records based on the plants and scenarios that they want to simulate.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>These characteristics are based on an estimation made with stationary simulations of a power plant simulation program.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end PQ_Characteristics_GuDFortuna;
