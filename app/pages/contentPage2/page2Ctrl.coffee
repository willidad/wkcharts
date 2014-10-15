angular.module('app').controller 'Page2Ctrl', ($log, $scope, $interval) ->

  $scope.longData = JSON.parse('[{"State":"CA","Under 5 Years":"2704659","5 to 13 Years":"4499890","14 to 17 Years":"2159981","18 to 24 Years":"3853788","25 to 44 Years":"10604510","45 to 64 Years":"8819342","65 Years and Over":"4114496","ages":[{"name":"Under 5 Years","y0":0,"y1":2704659},{"name":"5 to 13 Years","y0":2704659,"y1":7204549},{"name":"14 to 17 Years","y0":7204549,"y1":9364530},{"name":"18 to 24 Years","y0":9364530,"y1":13218318},{"name":"25 to 44 Years","y0":13218318,"y1":23822828},{"name":"45 to 64 Years","y0":23822828,"y1":32642170},{"name":"65 Years and Over","y0":32642170,"y1":36756666}],"total":36756666},{"State":"TX","Under 5 Years":"2027307","5 to 13 Years":"3277946","14 to 17 Years":"1420518","18 to 24 Years":"2454721","25 to 44 Years":"7017731","45 to 64 Years":"5656528","65 Years and Over":"2472223","ages":[{"name":"Under 5 Years","y0":0,"y1":2027307},{"name":"5 to 13 Years","y0":2027307,"y1":5305253},{"name":"14 to 17 Years","y0":5305253,"y1":6725771},{"name":"18 to 24 Years","y0":6725771,"y1":9180492},{"name":"25 to 44 Years","y0":9180492,"y1":16198223},{"name":"45 to 64 Years","y0":16198223,"y1":21854751},{"name":"65 Years and Over","y0":21854751,"y1":24326974}],"total":24326974},{"State":"NY","Under 5 Years":"1208495","5 to 13 Years":"2141490","14 to 17 Years":"1058031","18 to 24 Years":"1999120","25 to 44 Years":"5355235","45 to 64 Years":"5120254","65 Years and Over":"2607672","ages":[{"name":"Under 5 Years","y0":0,"y1":1208495},{"name":"5 to 13 Years","y0":1208495,"y1":3349985},{"name":"14 to 17 Years","y0":3349985,"y1":4408016},{"name":"18 to 24 Years","y0":4408016,"y1":6407136},{"name":"25 to 44 Years","y0":6407136,"y1":11762371},{"name":"45 to 64 Years","y0":11762371,"y1":16882625},{"name":"65 Years and Over","y0":16882625,"y1":19490297}],"total":19490297},{"State":"FL","Under 5 Years":"1140516","5 to 13 Years":"1938695","14 to 17 Years":"925060","18 to 24 Years":"1607297","25 to 44 Years":"4782119","45 to 64 Years":"4746856","65 Years and Over":"3187797","ages":[{"name":"Under 5 Years","y0":0,"y1":1140516},{"name":"5 to 13 Years","y0":1140516,"y1":3079211},{"name":"14 to 17 Years","y0":3079211,"y1":4004271},{"name":"18 to 24 Years","y0":4004271,"y1":5611568},{"name":"25 to 44 Years","y0":5611568,"y1":10393687},{"name":"45 to 64 Years","y0":10393687,"y1":15140543},{"name":"65 Years and Over","y0":15140543,"y1":18328340}],"total":18328340},{"State":"IL","Under 5 Years":"894368","5 to 13 Years":"1558919","14 to 17 Years":"725973","18 to 24 Years":"1311479","25 to 44 Years":"3596343","45 to 64 Years":"3239173","65 Years and Over":"1575308","ages":[{"name":"Under 5 Years","y0":0,"y1":894368},{"name":"5 to 13 Years","y0":894368,"y1":2453287},{"name":"14 to 17 Years","y0":2453287,"y1":3179260},{"name":"18 to 24 Years","y0":3179260,"y1":4490739},{"name":"25 to 44 Years","y0":4490739,"y1":8087082},{"name":"45 to 64 Years","y0":8087082,"y1":11326255},{"name":"65 Years and Over","y0":11326255,"y1":12901563}],"total":12901563},{"State":"PA","Under 5 Years":"737462","5 to 13 Years":"1345341","14 to 17 Years":"679201","18 to 24 Years":"1203944","25 to 44 Years":"3157759","45 to 64 Years":"3414001","65 Years and Over":"1910571","ages":[{"name":"Under 5 Years","y0":0,"y1":737462},{"name":"5 to 13 Years","y0":737462,"y1":2082803},{"name":"14 to 17 Years","y0":2082803,"y1":2762004},{"name":"18 to 24 Years","y0":2762004,"y1":3965948},{"name":"25 to 44 Years","y0":3965948,"y1":7123707},{"name":"45 to 64 Years","y0":7123707,"y1":10537708},{"name":"65 Years and Over","y0":10537708,"y1":12448279}],"total":12448279},{"State":"OH","Under 5 Years":"743750","5 to 13 Years":"1340492","14 to 17 Years":"646135","18 to 24 Years":"1081734","25 to 44 Years":"3019147","45 to 64 Years":"3083815","65 Years and Over":"1570837","ages":[{"name":"Under 5 Years","y0":0,"y1":743750},{"name":"5 to 13 Years","y0":743750,"y1":2084242},{"name":"14 to 17 Years","y0":2084242,"y1":2730377},{"name":"18 to 24 Years","y0":2730377,"y1":3812111},{"name":"25 to 44 Years","y0":3812111,"y1":6831258},{"name":"45 to 64 Years","y0":6831258,"y1":9915073},{"name":"65 Years and Over","y0":9915073,"y1":11485910}],"total":11485910},{"State":"MI","Under 5 Years":"625526","5 to 13 Years":"1179503","14 to 17 Years":"585169","18 to 24 Years":"974480","25 to 44 Years":"2628322","45 to 64 Years":"2706100","65 Years and Over":"1304322","ages":[{"name":"Under 5 Years","y0":0,"y1":625526},{"name":"5 to 13 Years","y0":625526,"y1":1805029},{"name":"14 to 17 Years","y0":1805029,"y1":2390198},{"name":"18 to 24 Years","y0":2390198,"y1":3364678},{"name":"25 to 44 Years","y0":3364678,"y1":5993000},{"name":"45 to 64 Years","y0":5993000,"y1":8699100},{"name":"65 Years and Over","y0":8699100,"y1":10003422}],"total":10003422},{"State":"GA","Under 5 Years":"740521","5 to 13 Years":"1250460","14 to 17 Years":"557860","18 to 24 Years":"919876","25 to 44 Years":"2846985","45 to 64 Years":"2389018","65 Years and Over":"981024","ages":[{"name":"Under 5 Years","y0":0,"y1":740521},{"name":"5 to 13 Years","y0":740521,"y1":1990981},{"name":"14 to 17 Years","y0":1990981,"y1":2548841},{"name":"18 to 24 Years","y0":2548841,"y1":3468717},{"name":"25 to 44 Years","y0":3468717,"y1":6315702},{"name":"45 to 64 Years","y0":6315702,"y1":8704720},{"name":"65 Years and Over","y0":8704720,"y1":9685744}],"total":9685744},{"State":"NC","Under 5 Years":"652823","5 to 13 Years":"1097890","14 to 17 Years":"492964","18 to 24 Years":"883397","25 to 44 Years":"2575603","45 to 64 Years":"2380685","65 Years and Over":"1139052","ages":[{"name":"Under 5 Years","y0":0,"y1":652823},{"name":"5 to 13 Years","y0":652823,"y1":1750713},{"name":"14 to 17 Years","y0":1750713,"y1":2243677},{"name":"18 to 24 Years","y0":2243677,"y1":3127074},{"name":"25 to 44 Years","y0":3127074,"y1":5702677},{"name":"45 to 64 Years","y0":5702677,"y1":8083362},{"name":"65 Years and Over","y0":8083362,"y1":9222414}],"total":9222414},{"State":"NJ","Under 5 Years":"557421","5 to 13 Years":"1011656","14 to 17 Years":"478505","18 to 24 Years":"769321","25 to 44 Years":"2379649","45 to 64 Years":"2335168","65 Years and Over":"1150941","ages":[{"name":"Under 5 Years","y0":0,"y1":557421},{"name":"5 to 13 Years","y0":557421,"y1":1569077},{"name":"14 to 17 Years","y0":1569077,"y1":2047582},{"name":"18 to 24 Years","y0":2047582,"y1":2816903},{"name":"25 to 44 Years","y0":2816903,"y1":5196552},{"name":"45 to 64 Years","y0":5196552,"y1":7531720},{"name":"65 Years and Over","y0":7531720,"y1":8682661}],"total":8682661},{"State":"VA","Under 5 Years":"522672","5 to 13 Years":"887525","14 to 17 Years":"413004","18 to 24 Years":"768475","25 to 44 Years":"2203286","45 to 64 Years":"2033550","65 Years and Over":"940577","ages":[{"name":"Under 5 Years","y0":0,"y1":522672},{"name":"5 to 13 Years","y0":522672,"y1":1410197},{"name":"14 to 17 Years","y0":1410197,"y1":1823201},{"name":"18 to 24 Years","y0":1823201,"y1":2591676},{"name":"25 to 44 Years","y0":2591676,"y1":4794962},{"name":"45 to 64 Years","y0":4794962,"y1":6828512},{"name":"65 Years and Over","y0":6828512,"y1":7769089}],"total":7769089},{"State":"WA","Under 5 Years":"433119","5 to 13 Years":"750274","14 to 17 Years":"357782","18 to 24 Years":"610378","25 to 44 Years":"1850983","45 to 64 Years":"1762811","65 Years and Over":"783877","ages":[{"name":"Under 5 Years","y0":0,"y1":433119},{"name":"5 to 13 Years","y0":433119,"y1":1183393},{"name":"14 to 17 Years","y0":1183393,"y1":1541175},{"name":"18 to 24 Years","y0":1541175,"y1":2151553},{"name":"25 to 44 Years","y0":2151553,"y1":4002536},{"name":"45 to 64 Years","y0":4002536,"y1":5765347},{"name":"65 Years and Over","y0":5765347,"y1":6549224}],"total":6549224},{"State":"AZ","Under 5 Years":"515910","5 to 13 Years":"828669","14 to 17 Years":"362642","18 to 24 Years":"601943","25 to 44 Years":"1804762","45 to 64 Years":"1523681","65 Years and Over":"862573","ages":[{"name":"Under 5 Years","y0":0,"y1":515910},{"name":"5 to 13 Years","y0":515910,"y1":1344579},{"name":"14 to 17 Years","y0":1344579,"y1":1707221},{"name":"18 to 24 Years","y0":1707221,"y1":2309164},{"name":"25 to 44 Years","y0":2309164,"y1":4113926},{"name":"45 to 64 Years","y0":4113926,"y1":5637607},{"name":"65 Years and Over","y0":5637607,"y1":6500180}],"total":6500180},{"State":"MA","Under 5 Years":"383568","5 to 13 Years":"701752","14 to 17 Years":"341713","18 to 24 Years":"665879","25 to 44 Years":"1782449","45 to 64 Years":"1751508","65 Years and Over":"871098","ages":[{"name":"Under 5 Years","y0":0,"y1":383568},{"name":"5 to 13 Years","y0":383568,"y1":1085320},{"name":"14 to 17 Years","y0":1085320,"y1":1427033},{"name":"18 to 24 Years","y0":1427033,"y1":2092912},{"name":"25 to 44 Years","y0":2092912,"y1":3875361},{"name":"45 to 64 Years","y0":3875361,"y1":5626869},{"name":"65 Years and Over","y0":5626869,"y1":6497967}],"total":6497967},{"State":"IN","Under 5 Years":"443089","5 to 13 Years":"780199","14 to 17 Years":"361393","18 to 24 Years":"605863","25 to 44 Years":"1724528","45 to 64 Years":"1647881","65 Years and Over":"813839","ages":[{"name":"Under 5 Years","y0":0,"y1":443089},{"name":"5 to 13 Years","y0":443089,"y1":1223288},{"name":"14 to 17 Years","y0":1223288,"y1":1584681},{"name":"18 to 24 Years","y0":1584681,"y1":2190544},{"name":"25 to 44 Years","y0":2190544,"y1":3915072},{"name":"45 to 64 Years","y0":3915072,"y1":5562953},{"name":"65 Years and Over","y0":5562953,"y1":6376792}],"total":6376792},{"State":"TN","Under 5 Years":"416334","5 to 13 Years":"725948","14 to 17 Years":"336312","18 to 24 Years":"550612","25 to 44 Years":"1719433","45 to 64 Years":"1646623","65 Years and Over":"819626","ages":[{"name":"Under 5 Years","y0":0,"y1":416334},{"name":"5 to 13 Years","y0":416334,"y1":1142282},{"name":"14 to 17 Years","y0":1142282,"y1":1478594},{"name":"18 to 24 Years","y0":1478594,"y1":2029206},{"name":"25 to 44 Years","y0":2029206,"y1":3748639},{"name":"45 to 64 Years","y0":3748639,"y1":5395262},{"name":"65 Years and Over","y0":5395262,"y1":6214888}],"total":6214888},{"State":"MO","Under 5 Years":"399450","5 to 13 Years":"690476","14 to 17 Years":"331543","18 to 24 Years":"560463","25 to 44 Years":"1569626","45 to 64 Years":"1554812","65 Years and Over":"805235","ages":[{"name":"Under 5 Years","y0":0,"y1":399450},{"name":"5 to 13 Years","y0":399450,"y1":1089926},{"name":"14 to 17 Years","y0":1089926,"y1":1421469},{"name":"18 to 24 Years","y0":1421469,"y1":1981932},{"name":"25 to 44 Years","y0":1981932,"y1":3551558},{"name":"45 to 64 Years","y0":3551558,"y1":5106370},{"name":"65 Years and Over","y0":5106370,"y1":5911605}],"total":5911605},{"State":"MD","Under 5 Years":"371787","5 to 13 Years":"651923","14 to 17 Years":"316873","18 to 24 Years":"543470","25 to 44 Years":"1556225","45 to 64 Years":"1513754","65 Years and Over":"679565","ages":[{"name":"Under 5 Years","y0":0,"y1":371787},{"name":"5 to 13 Years","y0":371787,"y1":1023710},{"name":"14 to 17 Years","y0":1023710,"y1":1340583},{"name":"18 to 24 Years","y0":1340583,"y1":1884053},{"name":"25 to 44 Years","y0":1884053,"y1":3440278},{"name":"45 to 64 Years","y0":3440278,"y1":4954032},{"name":"65 Years and Over","y0":4954032,"y1":5633597}],"total":5633597},{"State":"WI","Under 5 Years":"362277","5 to 13 Years":"640286","14 to 17 Years":"311849","18 to 24 Years":"553914","25 to 44 Years":"1487457","45 to 64 Years":"1522038","65 Years and Over":"750146","ages":[{"name":"Under 5 Years","y0":0,"y1":362277},{"name":"5 to 13 Years","y0":362277,"y1":1002563},{"name":"14 to 17 Years","y0":1002563,"y1":1314412},{"name":"18 to 24 Years","y0":1314412,"y1":1868326},{"name":"25 to 44 Years","y0":1868326,"y1":3355783},{"name":"45 to 64 Years","y0":3355783,"y1":4877821},{"name":"65 Years and Over","y0":4877821,"y1":5627967}],"total":5627967},{"State":"MN","Under 5 Years":"358471","5 to 13 Years":"606802","14 to 17 Years":"289371","18 to 24 Years":"507289","25 to 44 Years":"1416063","45 to 64 Years":"1391878","65 Years and Over":"650519","ages":[{"name":"Under 5 Years","y0":0,"y1":358471},{"name":"5 to 13 Years","y0":358471,"y1":965273},{"name":"14 to 17 Years","y0":965273,"y1":1254644},{"name":"18 to 24 Years","y0":1254644,"y1":1761933},{"name":"25 to 44 Years","y0":1761933,"y1":3177996},{"name":"45 to 64 Years","y0":3177996,"y1":4569874},{"name":"65 Years and Over","y0":4569874,"y1":5220393}],"total":5220393},{"State":"CO","Under 5 Years":"358280","5 to 13 Years":"587154","14 to 17 Years":"261701","18 to 24 Years":"466194","25 to 44 Years":"1464939","45 to 64 Years":"1290094","65 Years and Over":"511094","ages":[{"name":"Under 5 Years","y0":0,"y1":358280},{"name":"5 to 13 Years","y0":358280,"y1":945434},{"name":"14 to 17 Years","y0":945434,"y1":1207135},{"name":"18 to 24 Years","y0":1207135,"y1":1673329},{"name":"25 to 44 Years","y0":1673329,"y1":3138268},{"name":"45 to 64 Years","y0":3138268,"y1":4428362},{"name":"65 Years and Over","y0":4428362,"y1":4939456}],"total":4939456},{"State":"AL","Under 5 Years":"310504","5 to 13 Years":"552339","14 to 17 Years":"259034","18 to 24 Years":"450818","25 to 44 Years":"1231572","45 to 64 Years":"1215966","65 Years and Over":"641667","ages":[{"name":"Under 5 Years","y0":0,"y1":310504},{"name":"5 to 13 Years","y0":310504,"y1":862843},{"name":"14 to 17 Years","y0":862843,"y1":1121877},{"name":"18 to 24 Years","y0":1121877,"y1":1572695},{"name":"25 to 44 Years","y0":1572695,"y1":2804267},{"name":"45 to 64 Years","y0":2804267,"y1":4020233},{"name":"65 Years and Over","y0":4020233,"y1":4661900}],"total":4661900},{"State":"SC","Under 5 Years":"303024","5 to 13 Years":"517803","14 to 17 Years":"245400","18 to 24 Years":"438147","25 to 44 Years":"1193112","45 to 64 Years":"1186019","65 Years and Over":"596295","ages":[{"name":"Under 5 Years","y0":0,"y1":303024},{"name":"5 to 13 Years","y0":303024,"y1":820827},{"name":"14 to 17 Years","y0":820827,"y1":1066227},{"name":"18 to 24 Years","y0":1066227,"y1":1504374},{"name":"25 to 44 Years","y0":1504374,"y1":2697486},{"name":"45 to 64 Years","y0":2697486,"y1":3883505},{"name":"65 Years and Over","y0":3883505,"y1":4479800}],"total":4479800},{"State":"LA","Under 5 Years":"310716","5 to 13 Years":"542341","14 to 17 Years":"254916","18 to 24 Years":"471275","25 to 44 Years":"1162463","45 to 64 Years":"1128771","65 Years and Over":"540314","ages":[{"name":"Under 5 Years","y0":0,"y1":310716},{"name":"5 to 13 Years","y0":310716,"y1":853057},{"name":"14 to 17 Years","y0":853057,"y1":1107973},{"name":"18 to 24 Years","y0":1107973,"y1":1579248},{"name":"25 to 44 Years","y0":1579248,"y1":2741711},{"name":"45 to 64 Years","y0":2741711,"y1":3870482},{"name":"65 Years and Over","y0":3870482,"y1":4410796}],"total":4410796},{"State":"KY","Under 5 Years":"284601","5 to 13 Years":"493536","14 to 17 Years":"229927","18 to 24 Years":"381394","25 to 44 Years":"1179637","45 to 64 Years":"1134283","65 Years and Over":"565867","ages":[{"name":"Under 5 Years","y0":0,"y1":284601},{"name":"5 to 13 Years","y0":284601,"y1":778137},{"name":"14 to 17 Years","y0":778137,"y1":1008064},{"name":"18 to 24 Years","y0":1008064,"y1":1389458},{"name":"25 to 44 Years","y0":1389458,"y1":2569095},{"name":"45 to 64 Years","y0":2569095,"y1":3703378},{"name":"65 Years and Over","y0":3703378,"y1":4269245}],"total":4269245},{"State":"OR","Under 5 Years":"243483","5 to 13 Years":"424167","14 to 17 Years":"199925","18 to 24 Years":"338162","25 to 44 Years":"1044056","45 to 64 Years":"1036269","65 Years and Over":"503998","ages":[{"name":"Under 5 Years","y0":0,"y1":243483},{"name":"5 to 13 Years","y0":243483,"y1":667650},{"name":"14 to 17 Years","y0":667650,"y1":867575},{"name":"18 to 24 Years","y0":867575,"y1":1205737},{"name":"25 to 44 Years","y0":1205737,"y1":2249793},{"name":"45 to 64 Years","y0":2249793,"y1":3286062},{"name":"65 Years and Over","y0":3286062,"y1":3790060}],"total":3790060},{"State":"OK","Under 5 Years":"266547","5 to 13 Years":"438926","14 to 17 Years":"200562","18 to 24 Years":"369916","25 to 44 Years":"957085","45 to 64 Years":"918688","65 Years and Over":"490637","ages":[{"name":"Under 5 Years","y0":0,"y1":266547},{"name":"5 to 13 Years","y0":266547,"y1":705473},{"name":"14 to 17 Years","y0":705473,"y1":906035},{"name":"18 to 24 Years","y0":906035,"y1":1275951},{"name":"25 to 44 Years","y0":1275951,"y1":2233036},{"name":"45 to 64 Years","y0":2233036,"y1":3151724},{"name":"65 Years and Over","y0":3151724,"y1":3642361}],"total":3642361},{"State":"CT","Under 5 Years":"211637","5 to 13 Years":"403658","14 to 17 Years":"196918","18 to 24 Years":"325110","25 to 44 Years":"916955","45 to 64 Years":"968967","65 Years and Over":"478007","ages":[{"name":"Under 5 Years","y0":0,"y1":211637},{"name":"5 to 13 Years","y0":211637,"y1":615295},{"name":"14 to 17 Years","y0":615295,"y1":812213},{"name":"18 to 24 Years","y0":812213,"y1":1137323},{"name":"25 to 44 Years","y0":1137323,"y1":2054278},{"name":"45 to 64 Years","y0":2054278,"y1":3023245},{"name":"65 Years and Over","y0":3023245,"y1":3501252}],"total":3501252},{"State":"IA","Under 5 Years":"201321","5 to 13 Years":"345409","14 to 17 Years":"165883","18 to 24 Years":"306398","25 to 44 Years":"750505","45 to 64 Years":"788485","65 Years and Over":"444554","ages":[{"name":"Under 5 Years","y0":0,"y1":201321},{"name":"5 to 13 Years","y0":201321,"y1":546730},{"name":"14 to 17 Years","y0":546730,"y1":712613},{"name":"18 to 24 Years","y0":712613,"y1":1019011},{"name":"25 to 44 Years","y0":1019011,"y1":1769516},{"name":"45 to 64 Years","y0":1769516,"y1":2558001},{"name":"65 Years and Over","y0":2558001,"y1":3002555}],"total":3002555},{"State":"MS","Under 5 Years":"220813","5 to 13 Years":"371502","14 to 17 Years":"174405","18 to 24 Years":"305964","25 to 44 Years":"764203","45 to 64 Years":"730133","65 Years and Over":"371598","ages":[{"name":"Under 5 Years","y0":0,"y1":220813},{"name":"5 to 13 Years","y0":220813,"y1":592315},{"name":"14 to 17 Years","y0":592315,"y1":766720},{"name":"18 to 24 Years","y0":766720,"y1":1072684},{"name":"25 to 44 Years","y0":1072684,"y1":1836887},{"name":"45 to 64 Years","y0":1836887,"y1":2567020},{"name":"65 Years and Over","y0":2567020,"y1":2938618}],"total":2938618},{"State":"AR","Under 5 Years":"202070","5 to 13 Years":"343207","14 to 17 Years":"157204","18 to 24 Years":"264160","25 to 44 Years":"754420","45 to 64 Years":"727124","65 Years and Over":"407205","ages":[{"name":"Under 5 Years","y0":0,"y1":202070},{"name":"5 to 13 Years","y0":202070,"y1":545277},{"name":"14 to 17 Years","y0":545277,"y1":702481},{"name":"18 to 24 Years","y0":702481,"y1":966641},{"name":"25 to 44 Years","y0":966641,"y1":1721061},{"name":"45 to 64 Years","y0":1721061,"y1":2448185},{"name":"65 Years and Over","y0":2448185,"y1":2855390}],"total":2855390},{"State":"KS","Under 5 Years":"202529","5 to 13 Years":"342134","14 to 17 Years":"155822","18 to 24 Years":"293114","25 to 44 Years":"728166","45 to 64 Years":"713663","65 Years and Over":"366706","ages":[{"name":"Under 5 Years","y0":0,"y1":202529},{"name":"5 to 13 Years","y0":202529,"y1":544663},{"name":"14 to 17 Years","y0":544663,"y1":700485},{"name":"18 to 24 Years","y0":700485,"y1":993599},{"name":"25 to 44 Years","y0":993599,"y1":1721765},{"name":"45 to 64 Years","y0":1721765,"y1":2435428},{"name":"65 Years and Over","y0":2435428,"y1":2802134}],"total":2802134},{"State":"UT","Under 5 Years":"268916","5 to 13 Years":"413034","14 to 17 Years":"167685","18 to 24 Years":"329585","25 to 44 Years":"772024","45 to 64 Years":"538978","65 Years and Over":"246202","ages":[{"name":"Under 5 Years","y0":0,"y1":268916},{"name":"5 to 13 Years","y0":268916,"y1":681950},{"name":"14 to 17 Years","y0":681950,"y1":849635},{"name":"18 to 24 Years","y0":849635,"y1":1179220},{"name":"25 to 44 Years","y0":1179220,"y1":1951244},{"name":"45 to 64 Years","y0":1951244,"y1":2490222},{"name":"65 Years and Over","y0":2490222,"y1":2736424}],"total":2736424},{"State":"NV","Under 5 Years":"199175","5 to 13 Years":"325650","14 to 17 Years":"142976","18 to 24 Years":"212379","25 to 44 Years":"769913","45 to 64 Years":"653357","65 Years and Over":"296717","ages":[{"name":"Under 5 Years","y0":0,"y1":199175},{"name":"5 to 13 Years","y0":199175,"y1":524825},{"name":"14 to 17 Years","y0":524825,"y1":667801},{"name":"18 to 24 Years","y0":667801,"y1":880180},{"name":"25 to 44 Years","y0":880180,"y1":1650093},{"name":"45 to 64 Years","y0":1650093,"y1":2303450},{"name":"65 Years and Over","y0":2303450,"y1":2600167}],"total":2600167},{"State":"NM","Under 5 Years":"148323","5 to 13 Years":"241326","14 to 17 Years":"112801","18 to 24 Years":"203097","25 to 44 Years":"517154","45 to 64 Years":"501604","65 Years and Over":"260051","ages":[{"name":"Under 5 Years","y0":0,"y1":148323},{"name":"5 to 13 Years","y0":148323,"y1":389649},{"name":"14 to 17 Years","y0":389649,"y1":502450},{"name":"18 to 24 Years","y0":502450,"y1":705547},{"name":"25 to 44 Years","y0":705547,"y1":1222701},{"name":"45 to 64 Years","y0":1222701,"y1":1724305},{"name":"65 Years and Over","y0":1724305,"y1":1984356}],"total":1984356},{"State":"WV","Under 5 Years":"105435","5 to 13 Years":"189649","14 to 17 Years":"91074","18 to 24 Years":"157989","25 to 44 Years":"470749","45 to 64 Years":"514505","65 Years and Over":"285067","ages":[{"name":"Under 5 Years","y0":0,"y1":105435},{"name":"5 to 13 Years","y0":105435,"y1":295084},{"name":"14 to 17 Years","y0":295084,"y1":386158},{"name":"18 to 24 Years","y0":386158,"y1":544147},{"name":"25 to 44 Years","y0":544147,"y1":1014896},{"name":"45 to 64 Years","y0":1014896,"y1":1529401},{"name":"65 Years and Over","y0":1529401,"y1":1814468}],"total":1814468},{"State":"NE","Under 5 Years":"132092","5 to 13 Years":"215265","14 to 17 Years":"99638","18 to 24 Years":"186657","25 to 44 Years":"457177","45 to 64 Years":"451756","65 Years and Over":"240847","ages":[{"name":"Under 5 Years","y0":0,"y1":132092},{"name":"5 to 13 Years","y0":132092,"y1":347357},{"name":"14 to 17 Years","y0":347357,"y1":446995},{"name":"18 to 24 Years","y0":446995,"y1":633652},{"name":"25 to 44 Years","y0":633652,"y1":1090829},{"name":"45 to 64 Years","y0":1090829,"y1":1542585},{"name":"65 Years and Over","y0":1542585,"y1":1783432}],"total":1783432},{"State":"ID","Under 5 Years":"121746","5 to 13 Years":"201192","14 to 17 Years":"89702","18 to 24 Years":"147606","25 to 44 Years":"406247","45 to 64 Years":"375173","65 Years and Over":"182150","ages":[{"name":"Under 5 Years","y0":0,"y1":121746},{"name":"5 to 13 Years","y0":121746,"y1":322938},{"name":"14 to 17 Years","y0":322938,"y1":412640},{"name":"18 to 24 Years","y0":412640,"y1":560246},{"name":"25 to 44 Years","y0":560246,"y1":966493},{"name":"45 to 64 Years","y0":966493,"y1":1341666},{"name":"65 Years and Over","y0":1341666,"y1":1523816}],"total":1523816},{"State":"ME","Under 5 Years":"71459","5 to 13 Years":"133656","14 to 17 Years":"69752","18 to 24 Years":"112682","25 to 44 Years":"331809","45 to 64 Years":"397911","65 Years and Over":"199187","ages":[{"name":"Under 5 Years","y0":0,"y1":71459},{"name":"5 to 13 Years","y0":71459,"y1":205115},{"name":"14 to 17 Years","y0":205115,"y1":274867},{"name":"18 to 24 Years","y0":274867,"y1":387549},{"name":"25 to 44 Years","y0":387549,"y1":719358},{"name":"45 to 64 Years","y0":719358,"y1":1117269},{"name":"65 Years and Over","y0":1117269,"y1":1316456}],"total":1316456},{"State":"NH","Under 5 Years":"75297","5 to 13 Years":"144235","14 to 17 Years":"73826","18 to 24 Years":"119114","25 to 44 Years":"345109","45 to 64 Years":"388250","65 Years and Over":"169978","ages":[{"name":"Under 5 Years","y0":0,"y1":75297},{"name":"5 to 13 Years","y0":75297,"y1":219532},{"name":"14 to 17 Years","y0":219532,"y1":293358},{"name":"18 to 24 Years","y0":293358,"y1":412472},{"name":"25 to 44 Years","y0":412472,"y1":757581},{"name":"45 to 64 Years","y0":757581,"y1":1145831},{"name":"65 Years and Over","y0":1145831,"y1":1315809}],"total":1315809},{"State":"HI","Under 5 Years":"87207","5 to 13 Years":"134025","14 to 17 Years":"64011","18 to 24 Years":"124834","25 to 44 Years":"356237","45 to 64 Years":"331817","65 Years and Over":"190067","ages":[{"name":"Under 5 Years","y0":0,"y1":87207},{"name":"5 to 13 Years","y0":87207,"y1":221232},{"name":"14 to 17 Years","y0":221232,"y1":285243},{"name":"18 to 24 Years","y0":285243,"y1":410077},{"name":"25 to 44 Years","y0":410077,"y1":766314},{"name":"45 to 64 Years","y0":766314,"y1":1098131},{"name":"65 Years and Over","y0":1098131,"y1":1288198}],"total":1288198},{"State":"RI","Under 5 Years":"60934","5 to 13 Years":"111408","14 to 17 Years":"56198","18 to 24 Years":"114502","25 to 44 Years":"277779","45 to 64 Years":"282321","65 Years and Over":"147646","ages":[{"name":"Under 5 Years","y0":0,"y1":60934},{"name":"5 to 13 Years","y0":60934,"y1":172342},{"name":"14 to 17 Years","y0":172342,"y1":228540},{"name":"18 to 24 Years","y0":228540,"y1":343042},{"name":"25 to 44 Years","y0":343042,"y1":620821},{"name":"45 to 64 Years","y0":620821,"y1":903142},{"name":"65 Years and Over","y0":903142,"y1":1050788}],"total":1050788},{"State":"MT","Under 5 Years":"61114","5 to 13 Years":"106088","14 to 17 Years":"53156","18 to 24 Years":"95232","25 to 44 Years":"236297","45 to 64 Years":"278241","65 Years and Over":"137312","ages":[{"name":"Under 5 Years","y0":0,"y1":61114},{"name":"5 to 13 Years","y0":61114,"y1":167202},{"name":"14 to 17 Years","y0":167202,"y1":220358},{"name":"18 to 24 Years","y0":220358,"y1":315590},{"name":"25 to 44 Years","y0":315590,"y1":551887},{"name":"45 to 64 Years","y0":551887,"y1":830128},{"name":"65 Years and Over","y0":830128,"y1":967440}],"total":967440},{"State":"DE","Under 5 Years":"59319","5 to 13 Years":"99496","14 to 17 Years":"47414","18 to 24 Years":"84464","25 to 44 Years":"230183","45 to 64 Years":"230528","65 Years and Over":"121688","ages":[{"name":"Under 5 Years","y0":0,"y1":59319},{"name":"5 to 13 Years","y0":59319,"y1":158815},{"name":"14 to 17 Years","y0":158815,"y1":206229},{"name":"18 to 24 Years","y0":206229,"y1":290693},{"name":"25 to 44 Years","y0":290693,"y1":520876},{"name":"45 to 64 Years","y0":520876,"y1":751404},{"name":"65 Years and Over","y0":751404,"y1":873092}],"total":873092},{"State":"SD","Under 5 Years":"58566","5 to 13 Years":"94438","14 to 17 Years":"45305","18 to 24 Years":"82869","25 to 44 Years":"196738","45 to 64 Years":"210178","65 Years and Over":"116100","ages":[{"name":"Under 5 Years","y0":0,"y1":58566},{"name":"5 to 13 Years","y0":58566,"y1":153004},{"name":"14 to 17 Years","y0":153004,"y1":198309},{"name":"18 to 24 Years","y0":198309,"y1":281178},{"name":"25 to 44 Years","y0":281178,"y1":477916},{"name":"45 to 64 Years","y0":477916,"y1":688094},{"name":"65 Years and Over","y0":688094,"y1":804194}],"total":804194},{"State":"AK","Under 5 Years":"52083","5 to 13 Years":"85640","14 to 17 Years":"42153","18 to 24 Years":"74257","25 to 44 Years":"198724","45 to 64 Years":"183159","65 Years and Over":"50277","ages":[{"name":"Under 5 Years","y0":0,"y1":52083},{"name":"5 to 13 Years","y0":52083,"y1":137723},{"name":"14 to 17 Years","y0":137723,"y1":179876},{"name":"18 to 24 Years","y0":179876,"y1":254133},{"name":"25 to 44 Years","y0":254133,"y1":452857},{"name":"45 to 64 Years","y0":452857,"y1":636016},{"name":"65 Years and Over","y0":636016,"y1":686293}],"total":686293},{"State":"ND","Under 5 Years":"41896","5 to 13 Years":"67358","14 to 17 Years":"33794","18 to 24 Years":"82629","25 to 44 Years":"154913","45 to 64 Years":"166615","65 Years and Over":"94276","ages":[{"name":"Under 5 Years","y0":0,"y1":41896},{"name":"5 to 13 Years","y0":41896,"y1":109254},{"name":"14 to 17 Years","y0":109254,"y1":143048},{"name":"18 to 24 Years","y0":143048,"y1":225677},{"name":"25 to 44 Years","y0":225677,"y1":380590},{"name":"45 to 64 Years","y0":380590,"y1":547205},{"name":"65 Years and Over","y0":547205,"y1":641481}],"total":641481},{"State":"VT","Under 5 Years":"32635","5 to 13 Years":"62538","14 to 17 Years":"33757","18 to 24 Years":"61679","25 to 44 Years":"155419","45 to 64 Years":"188593","65 Years and Over":"86649","ages":[{"name":"Under 5 Years","y0":0,"y1":32635},{"name":"5 to 13 Years","y0":32635,"y1":95173},{"name":"14 to 17 Years","y0":95173,"y1":128930},{"name":"18 to 24 Years","y0":128930,"y1":190609},{"name":"25 to 44 Years","y0":190609,"y1":346028},{"name":"45 to 64 Years","y0":346028,"y1":534621},{"name":"65 Years and Over","y0":534621,"y1":621270}],"total":621270},{"State":"DC","Under 5 Years":"36352","5 to 13 Years":"50439","14 to 17 Years":"25225","18 to 24 Years":"75569","25 to 44 Years":"193557","45 to 64 Years":"140043","65 Years and Over":"70648","ages":[{"name":"Under 5 Years","y0":0,"y1":36352},{"name":"5 to 13 Years","y0":36352,"y1":86791},{"name":"14 to 17 Years","y0":86791,"y1":112016},{"name":"18 to 24 Years","y0":112016,"y1":187585},{"name":"25 to 44 Years","y0":187585,"y1":381142},{"name":"45 to 64 Years","y0":381142,"y1":521185},{"name":"65 Years and Over","y0":521185,"y1":591833}],"total":591833},{"State":"WY","Under 5 Years":"38253","5 to 13 Years":"60890","14 to 17 Years":"29314","18 to 24 Years":"53980","25 to 44 Years":"137338","45 to 64 Years":"147279","65 Years and Over":"65614","ages":[{"name":"Under 5 Years","y0":0,"y1":38253},{"name":"5 to 13 Years","y0":38253,"y1":99143},{"name":"14 to 17 Years","y0":99143,"y1":128457},{"name":"18 to 24 Years","y0":128457,"y1":182437},{"name":"25 to 44 Years","y0":182437,"y1":319775},{"name":"45 to 64 Years","y0":319775,"y1":467054},{"name":"65 Years and Over","y0":467054,"y1":532668}],"total":532668}]')
  for d in $scope.longData
    delete d.ages
    delete d.total
  ###
  $interval(() =>
    cats = ['Under 5 Years','5 to 13 Years', '14 to 17 Years','18 to 24 Years','45 to 64 Years','65 Years and Over']
    idx = Math.floor(Math.random() * ($scope.longData.length - 1))
    idx2 = Math.floor(Math.random() * ($scope.longData.length - 1))
    idx3 = Math.floor(Math.random() * cats.length)
    nv = Math.round(Math.random() * 20000000)

    $scope.longData[idx][cats[idx3]] = nv
    #$scope.longData.splice idx2,1
  , 1000 , 20)

###

  $scope.ldKeys = d3.keys($scope.longData[0]).filter((d)->d isnt 'State').map((d) -> {name:d, data:true, domain:true})
  $scope.categories = cats = ['Under 5 Years','5 to 13 Years', '14 to 17 Years','18 to 24 Years',"25 to 44 Years",'45 to 64 Years','65 Years and Over']


  shortData = angular.copy($scope.longData).slice(0,18)

  $scope.shortData = shortData
  $scope.duration = 2000

  $scope.rowSelect = $scope.shortData.map((d) ->
    {name:d.State, include:true}
  )

  $scope.UpdateShortData = () ->
    $scope.domList = $scope.ldKeys.filter((d)->d.domain).map((d) -> d.name).join(',')

    $scope.shortDataFilter = $scope.shortData.filter((d,i) -> $scope.rowSelect[i].include).map((d) ->
      nv = {}
      for k in $scope.ldKeys
        if k.data then nv[k.name] = +d[k.name]
      nv.State = d.State
      return nv
    )

  $scope.reset = () ->
    $scope.shortData = angular.copy($scope.longData).slice(0,18)
    $scope.UpdateShortData()

  $scope.toggleShortList = () ->
    $scope.rowSelect = $scope.shortData.map((d,i) ->
      {name:d.State, include:i<=5 or not $scope.showShortData}
    )
    $scope.UpdateShortData()

  $scope.UpdateShortData()