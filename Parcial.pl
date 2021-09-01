/*
Age of Empires II es un videojuego de estrategia en tiempo real para computadoras 
personales desarrollado en un principio por Ensemble Studios y más tarde por
Skybox Labs. Fue lanzado a mediados de 1999 y es el segundo título que compone
la serie Age of Empires.
Nos contratan para hacer una nueva versión del juego en el lenguaje Prolog ya
que este es ultra mainstream. Para empezar, tenemos jugadores de quienes sabemos
su nombre, su rating y su civilización favorita. También sabemos qué unidades
(y cuántas), recursos (Madera, Alimento, Oro) y edificios (y cuántos) 
tiene cada jugador.
*/
% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).
% … y muchos más también
% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).
% … y muchos más también
%% De las unidades sabemos que pueden ser militares o aldeanos.
/*
● De los militares sabemos su tipo, cuántos recursos cuesta y a qué categoría 
pertenece.
● De los aldeanos sabemos su tipo y cuántos recursos por minuto produce. }
Su categoría es aldeano
*/

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).
% … y muchos más tipos pertenecientes a estas categorías.
% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).
% … y muchos más también
%% De los edificios sabemos su tipo y el costo de construcción.
% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).
% … y muchos más también


%% Crear los siguientes predicados de manera que sean totalmente inversibles:
/*
1) Definir el predicado esUnAfano/2, que nos dice si al jugar el primero contra 
el segundo, la diferencia de rating entre el primero y el segundo es mayor a 500.
*/

esUnAfano(Jugador1,Jugador2):-
    jugador(Jugador1,Rating1,_),
    jugador(Jugador2,Rating2,_),
    DiferenciaConSigno is Rating1-Rating2,
    abs(DiferenciaConSigno,Diferencia),
    Diferencia>500.


/*
2) Definir el predicado esEfectivo/2, que relaciona dos unidades si la primera
puede ganarle a la otra según su categoría, dado por el siguiente piedra, 
papel o tijeras:
a) La caballería le gana a la arquería.
b) La arquería le gana a la infantería.
c) La infantería le gana a los piqueros.
d) Los piqueros le ganan a la caballería.
Por otro lado, los Samuráis son efectivos contra otras unidades únicas 
(incluidos los samurái).Los aldeanos nunca son efectivos contra otras unidades

*/
esEfectivo(Unidad1,Unidad2):-
    militar(Unidad1,_,Categoria1),
    militar(Unidad2,_,Categoria2),
    gana(Categoria1,Categoria2).

esEfectivo(samurai,Unidad2):-
    militar(Unidad2,_,unica).

gana(caballeria,arquria).
gana(arqueria,infanteria).
gana(infanteria,piqueros).
gana(piqueros,caballeria).

/*
3) Definir el predicado alarico/1 que se cumple para un jugador si solo 
tiene unidades de infantería
*/
soloTieneUnidadesMilitaresDe(Jugador,UnidadUnica):-
    jugador(Jugador,_,_),
    forall(tiene(Jugador,unidad(Unidad,_)),militar(Unidad,_,UnidadUnica)).

alarico(Jugador):-
    soloTieneUnidadesMilitaresDe(Jugador,infanteria).

/*
4) Definir el predicado leonidas/1, que se cumple para un jugador si solo tiene
 unidades de piqueros.
*/
leonidas(Jugador):-
    soloTieneUnidadesMilitaresDe(Jugador,piquero).

/*
5) Definir el predicado nomada/1, que se cumple para un jugador si no tiene casas
*/
nomada(Jugador):-
    jugador(Jugador,_,_),
    not(tiene(Jugador,edificio(casa,_))).

/*
6) Definir el predicado cuantoCuesta/2, que relaciona una unidad o edificio con su 
costo. De las unidades militares y de los edificios conocemos sus costos. 
Los aldeanos cuestan 50 unidades de alimento. Las carretas y urnas mercantes cuestan
100 unidades de madera y 50 de oro cada una.
*/
cuantoCuesta(Objeto,Costo):-
    militar(Objeto,Costo,_).

cuantoCuesta(Objeto,Costo):-
    edificio(Objeto,Costo).

cuantoCuesta(Objeto,costo(0,50,0)):-
    aldeano(Objeto,_).

cuantoCuesta(carreta,costo(100,0,50)).
cuantoCuesta(urnaMercante,costo(100,0,50)).

/*
7) Definir el predicado produccion/2, que relaciona una unidad con su producción de
recursos por minuto. De los aldeanos, según su profesión, se conoce su producción. 
Las carretas y urnas mercantes producen 32 unidades de oro por minuto. Las unidades 
militares no producen ningún recurso, salvo los Keshiks, que producen 10 de oro por 
minuto.
*/

produccion(Unidad,Produccion):-
    aldeano(Unidad,Produccion).

produccion(carreta,produce(0,0,32)).
produccion(urnaMercante,produce(0,0,32)).
produccion(keshik,produce(0,0,10)).
produccion(Unidad,produce(0,0,0)):-
    militar(Unidad,_,_),
    Unidad\=keshik.


/*
8) Definir el predicado produccionTotal/3 que relaciona a un jugador con su 
producción total por minuto de cierto recurso, que se calcula como la suma de la 
producción total de todas sus unidades de ese recurso.
*/

produccionTotal(Jugador,Recurso,ProduccionTotal):-
    jugador(Jugador,_,_),
    cantidad(Recurso,_,_),
    findall(CantRecurso,cantProducidaPorUnidades(Jugador,Recurso,CantRecurso),ListaCantRecursos),
    sumlist(ListaCantRecursos,ProduccionTotal).

cantProducidaPorUnidades(Jugador,Recurso,CantRecurso):-
    tiene(Jugador,unidad(Unidad,_)),
    produccion(Unidad,Produccion),
    cantidad(Recurso,Produccion,CantRecurso).

cantidad(madera,produccion(CantRecurso,_,_),CantRecurso).
cantidad(alimento,produccion(_,CantRecurso,_),CantRecurso).
cantidad(oro,produccion(_,_,CantRecurso),CantRecurso).


/*
9) Definir el predicado estaPeleado/2 que se cumple para dos jugadores cuando no es 
un afano para ninguno, tienen la misma cantidad de unidades y la diferencia de valor
entre su producción total de recursos por minuto es menor a 100 . 
¡Pero cuidado! No todos los recursos valen lo mismo: el oro vale cinco veces su
cantidad; la madera, tres veces; y los alimentos, dos veces.
*/

estaPeleado(Jugador1,Jugador2):-
    not(esUnAfano(Jugador1,Jugador2)),
    not(esUnAfano(Jugador2,Jugador1)),
    totalUnidades(Jugador1,TotalUnidades),
    totalUnidades(Jugador2,TotalUnidades),
    produccionTotalValor(Jugador1,ProduccionTotal1),
    produccionTotalValor(Jugador2,ProduccionTotal2),
    DiferenciaConSigno is ProduccionTotal1-ProduccionTotal2,
    abs(DiferenciaConSigno,Diferencia),
    Diferencia<100.

totalUnidades(Jugador,TotalUnidades):-
    findall(Unidad,tiene(Jugador,unidad(Unidad,_)),ListaUnidades),
    length(ListaUnidades,TotalUnidades).

produccionTotalValor(Jugador,ProduccionTotalValor):-
    produccionTotal(Jugador,madera,ProduccionTotalMadera),
    produccionTotal(Jugador,alimento,ProduccionTotalAlimento),
    produccionTotal(Jugador,oro,ProduccionTotalOro),
    ProduccionTotalValor is ProduccionTotalOro*5+ProduccionTotalMadera*3+ProduccionTotalAlimento*2.

/*10) Definir el predicado avanzaA/2 que relaciona un jugador y una edad si este
puede avanzar a ella:
a) Siempre se puede avanzar a la edad media.
b) Puede avanzar a edad feudal si tiene al menos 500 unidades de alimento y una casa.
c) Puede avanzar a edad de los castillos si tiene al menos 800 unidades de alimento
y 200 de oro. También es necesaria una herrería, un establo o una galería de tiro.
d) Puede avanzar a edad imperial con 1000 unidades de alimento, 800 de oro, un 
castillo y una universidad.
*/
avanzaA(Jugador,Edad):-
    jugador(Jugador,_,_),
    puedeAvanzar(Jugador,Edad).

puedeAvanzar(_,edadMedia).

puedeAvanzar(Jugador,edadFeudal):-
    not(nomada(Jugador)),
    produccionTotal(Jugador,alimento,ProduccionTotalAlimento),
    ProduccionTotalAlimento>=500.

puedeAvanzar(Jugador,edadDeLosCastillos):-
    produccionTotal(Jugador,alimento,ProduccionTotalAlimento),
    produccionTotal(Jugador,oro,ProduccionTotalOro),
    poseeEdificioPiola(Jugador),
    ProduccionTotalAlimento>=800,
    ProduccionTotalOro>=200.

puedeAvanzar(Jugador,edadImperial):-
    produccionTotal(Jugador,alimento,ProduccionTotalAlimento),
    produccionTotal(Jugador,oro,ProduccionTotalOro),
    tiene(Jugador,edificio(castillo,_)),
    tiene(Jugador,edificio(universidad,_)),
    ProduccionTotalOro>=800,
    ProduccionTotalAlimento>=1000.

poseeEdificioPiola(Jugador):-
    tiene(Jugador,edificio(Edificio,_)),
    esPiola(Edificio).

esPiola(herreria).
esPiola(establo).
esPiola(galeriaDeTiro).

