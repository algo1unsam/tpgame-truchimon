import wollok.game.*
import entrenador.*
import batalla.*

object truchimonesTotales{
	method tipos() = [	new Charmilion(), new Ponita(), new Lifeon(), new Medestapod (), new Grukey(), 
						new Jorsi(), new Sil(), new Jeodud(), new Umbrion(), new Magnemait(), new Aaron(), 
						new Glacion(), new Wivil(), new Zumbat(), new Spirrou(), new Iivii(), new Miau()	]		
}

class Truchimon{
	//Definicion de variables
	var property saludMaxima = null 						// max health
	var property salud = saludMaxima 						// salud actual
	var property estado = salvaje							// identifica si tiene o no dueño	
	var property ataque = null   							// Añade Daño al movimiento que use
	var property ataqueEspecial = null
	var property nivelActual = 1
	var property experiencia = 0
		
	const property movimientos = []
	const property movimientosPosibles = []
	const maxMovimientos = 4
	var property visible = false
	var property position = game.origin() 					// Ver despues que hacer con la posicion en la jungla
		
	const property num = null 								// Numero del tipo -> truchif{01}.png siendo el nro el valor entre {}
	
	method esInvisibleEnJungla()=true
	method esTruchimon()=true
	method movimientosBase() = [tacle]
	method movimientosPosibles() = [trompada, laManoDeDios]
	method movimientos() = self.movimientosBase() + movimientos
	 
	method nombre()= self.printString().replace('un/a  ','')
	
	// Aprende el siguiente en la lista de posibles según su nivel
	method aprenderMovimiento(){
		const movimientoMejorado = self.movimientosPosibles().get(nivelActual-1)		
		if (!self.puedoAprender()) { self.olvidarUnMovimiento() } // si no puedo aprender borro el obsoleto 
		movimientos.add(movimientoMejorado)		
		game.say(self, self.printString() + " aprendió a usar " + movimientoMejorado.nombre())
	}
	
	method olvidarUnMovimiento(){
		const movimientoObsoleto = movimientos.first()
		movimientos.remove(movimientoObsoleto)
		game.say(self, self.printString() + " olvidó " + movimientoObsoleto.nombre())
	}
	
	method puedoAprender() = (maxMovimientos > self.movimientos().size())
	
	method expPorLevel() = 100*1.3**(nivelActual+1)
	
	// Retorna el Valor del png necesario para la imagen
	method image() {
		if (self.visible()){
			return ('truchi' + self.perfilPoke() + num + '.png')
		}
		return 'vacio.png'
	}
	
	// La imagen debe mostrarse en pantalla de frente, izq o derecha en base al estado del truchi
	method perfilPoke() = estado.perfilPoke()
			
	//Logica de niveles y aprender movimientos
	method subeDeNivel(){
		if( experiencia >= self.expPorLevel() and nivelActual < 5 ){
			game.say(self, self.printString() + " subio a nivel -> " + nivelActual.toString())
			self.aumentoDeStats()
			self.aprenderMovimiento()
			nivelActual += 1
		}
	}	
	
	method ganarXP(){
		experiencia += 200
	}
	
	method aumentoDeStats(){
		saludMaxima += 15
		ataque += nivelActual-1
		ataqueEspecial += nivelActual -1 	
	}	
	
	//Dinamicas ataques
	method atacar(truchimon, movimiento){ //Al atacar a otro truchimon hago que ejecute su metodo recibirAtaque
		if (truchimon.puedeEsquivar()){			
			game.say(truchimon,'OLEEEE TE ESQUIVE')
		} else {
			game.schedule(1000, {game.say(self, 'Te ataco con ' + movimiento.nombre())})
			truchimon.recibirAtaque(movimiento,self)
			if(self.tipo().esPlanta() and movimiento.esTipoPlanta()) self.curarse(truchimon, movimiento)
		}
	}
	
	method recibirAtaque(movimiento, atacante){//Reduce la salud en base al danio generado por el ataque multiplicado por el factor de tipos
		salud = 0.max(salud - self.danioRecibido(movimiento, atacante))
	}
	
	method danioRecibido(movimiento,atacante){
		return movimiento.danioEfectivo(atacante)*self.factorDeTipos(movimiento)
	}
	
	method factorDeTipos(mov){ //Si soy resistente, el danio del ataque se reduce a la mitad, si soy debil es el doble y si no es ninguno, va directo.
		return if ( self.tipo().soyResistenteA(mov)) 1/2 else if(self.tipo().soyDebilA(mov)) 2 else 1
	}	
	
	method curarse(truchimon,movimiento){
		salud = saludMaxima.min(salud + truchimon.danioRecibido(movimiento,self)/2)
	}
	
	method revivir(){
		salud = saludMaxima
	}
	
	method vivo() = (salud>0)
	
	method puedeEsquivar() =  self.tipo().puedeEsquivar()
		
	method tieneEsteAtaque(indice){
		return movimientos.size()>indice
	}
	method tipo() = normal
}
// end of truchimon

// start of truchis con afinidad
class TruchimonFuego inherits Truchimon{
	override method tipo() = fuego
	override method movimientosBase() = super() + [estrellita]
	override method movimientosPosibles() = (super() + [fogon, asado]).sortedBy({ a,b => a.id() < b.id()})
}

class TruchimonPlanta inherits Truchimon{
	override method tipo() = planta
	override method movimientosBase() = super() + [matecito]
	override method movimientosPosibles() = (super() + [fotosintesis, pachamama]).sortedBy({ a,b => a.id() < b.id()})
}

class TruchimonAgua inherits Truchimon{
	override method tipo() = agua	
	override method movimientosBase() = super() + [escupitajo]
	override method movimientosPosibles() = (super() + [sodazo, catarata]).sortedBy({ a,b => a.id() < b.id()})
}

class TruchimonTierra inherits Truchimon{
	override method tipo() = tierra
	override method movimientosBase() = super() + [barro]
	override method movimientosPosibles() = (super() + [pozo, zanja]).sortedBy({ a,b => a.id() < b.id()})
}
class TruchimonMetal inherits Truchimon{
	override method tipo() = metal
	override method movimientosBase() = super() + [tramontina]
	override method movimientosPosibles() = (super() + [fierrazo, cacerolazo]).sortedBy({ a,b => a.id() < b.id()})
}

class TruchimonHielo inherits Truchimon{
	override method tipo() = hielo
	override method movimientosBase() = super() + [cubito]
	override method movimientosPosibles() = (super() + [sambayon, granizo]).sortedBy({ a,b => a.id() < b.id()})
}

class TruchimonViento inherits Truchimon{
	override method tipo() = viento
	override method movimientosBase() = super() + [flatulencia]
	override method movimientosPosibles() = (super() + [eructo, bubuzela]).sortedBy({ a,b => a.id() < b.id()})
}

class TruchimonNormal inherits Truchimon{
	
}

class Movimiento {
	const property id = null
	const property nombre = null
	const property tipo = null
	const danioBase = null
	//const imagen=null si da el tiempo agregar

	method danioEfectivo(truchimon){//dependiendo del tipo de ataque, uso el stat ataque o ataqueEspecial del truchimon
		return danioBase + tipo.factorDeAtaque(truchimon)
	}
	
	//method image()=imagen //Para poder mostrar los ataques que uno tiene, wollok no tiene buen texto 

	method esTipoPlanta() = false
	
}

class MovimientoPlanta inherits Movimiento{
	override method esTipoPlanta() = true
}

class Tipo{
	var property debilidades = []
	var property resistencias = []
	
	method agregarDebilidades(lista){
		debilidades.addAll(lista)
	}

	method agregarResistencias(lista){
		resistencias.addAll(lista)
	}	
	
	method factorDeAtaque(atacante){
		return atacante.ataqueEspecial()
	}
	
	method soyResistenteA(mov){
		return resistencias.contains(mov.tipo())
	}

	method soyDebilA(mov){
		return debilidades.contains(mov.tipo())
	}
	
	method esPlanta(){
		return false
	}
	
	method puedeEsquivar() = false	
}

class TipoEsquivador inherits Tipo{
	override method puedeEsquivar() = return 1.randomUpTo(100) < 10
}

object fuego inherits Tipo {
	
}

object agua inherits Tipo {
	
}

object tierra inherits Tipo {
	
}

object metal inherits Tipo {
	
}

object normal inherits Tipo{
	override method factorDeAtaque(atacante){
		return atacante.ataque()
	}
}

object planta inherits Tipo{	
	override method esPlanta(){
		return true
	}	
}

object viento inherits TipoEsquivador{	
	override method puedeEsquivar() = 1.randomUpTo(100) <= 25
}

object hielo inherits TipoEsquivador{	
	override method puedeEsquivar() = 1.randomUpTo(100) < 15
}

//Definicion de tipos
//Mas ataque especial menos ataque R3D3
//const agua = new Tipo() //Mas equilibrado R2D2
//const planta = new Tipo() //Menos ataque especial Se regenera R2D4
//const normal = new Tipo() //Equilibradonada R0D0 al principio es re verga pero al final aprende los ataques re poderosos tipo comodin
//const tierra = new Tipo() //Mas salud++ menos ataque R1D3
//const metal = new Tipo() //Mas ataque++ menos salud R3D2
//const viento = new Tipo() //debil pero esquiva mucho R2D0
//const hielo = new Tipo() // Mas salud y esquiva  R1D3

object settingDeTipos{
	method ejecutar(){
		fuego.agregarDebilidades([agua,tierra,viento])
		fuego.agregarResistencias([planta,metal,hielo])
		agua.agregarDebilidades([planta,hielo])
		agua.agregarResistencias([fuego,tierra])
		planta.agregarDebilidades([fuego,viento,metal,hielo])
		planta.agregarResistencias([agua,tierra])
		viento.agregarResistencias([fuego,planta])
		tierra.agregarDebilidades([agua,planta,metal])
		tierra.agregarResistencias([viento])
		metal.agregarDebilidades([fuego,viento])
		metal.agregarResistencias([planta,tierra,hielo])
		hielo.agregarDebilidades([fuego,agua,metal])
		hielo.agregarResistencias([planta])		
	}	
}

//Ejemplos de Truchimones, porfa dejemoslos tipo easteregg
//const verguigneo = new TruchimonFuego(estado=entrenado, num='20',tipo=fuego,saludMaxima=20,ataque=10,ataqueEspecial=10)
//const bulbasaur = new Truchimon(estado=salvaje, num='02',tipo=planta,saludMaxima=20,ataque=10,ataqueEspecial=10,movimientos=[tacle,matecito,trompada,fotosintesis])
//const mikali = new Truchimon(estado=enemigo, lklknum='21',tipo=metal,saludMaxima=20,ataque=10,ataqueEspecial=10)

//Truchimones posta, son presets, los personalizamos despues
//Salud base 20
//Ataque base 4
//Ataque especial base = 4


class Charmilion inherits  	TruchimonFuego ( saludMaxima=20, ataque=3, ataqueEspecial=5, num='01' ){}	//truchi01
class Ponita inherits  		TruchimonFuego ( saludMaxima=20, ataque=4, ataqueEspecial=5, num='15' ){}	//truchi15

class Lifeon inherits 		TruchimonPlanta( saludMaxima=20, ataque=4, ataqueEspecial=3, num='02' ){}	//truchi02
class Medestapod inherits 	TruchimonPlanta( saludMaxima=30, ataque=3, ataqueEspecial=1, num='07' ){}	//truchi07
class Grukey inherits 		TruchimonPlanta( saludMaxima=20, ataque=4, ataqueEspecial=2, num='11' ){}	//truchi11

class Jorsi inherits 		TruchimonAgua  ( saludMaxima=20, ataque=4, ataqueEspecial=4, num='09' ){}	//truchi09
class Sil inherits 			TruchimonAgua  ( saludMaxima=20, ataque=4, ataqueEspecial=4, num='16' ){}	//truchi16

class Jeodud inherits 		TruchimonTierra( saludMaxima=30, ataque=3, ataqueEspecial=4, num='10' ){}	//truchi10
class Umbrion inherits 		TruchimonTierra( saludMaxima=35, ataque=3, ataqueEspecial=3, num='03' ){}	//truchi03

class Magnemait inherits 	TruchimonMetal ( saludMaxima=15, ataque=4, ataqueEspecial=6, num='12' ){}	//truchi12
class Aaron inherits 		TruchimonMetal ( saludMaxima=15, ataque=4, ataqueEspecial=6, num='04' ){}	//truchi04

class Glacion inherits 		TruchimonHielo ( saludMaxima=30, ataque=4, ataqueEspecial=4, num='13' ){}	//truchi13
class Wivil inherits 		TruchimonHielo ( saludMaxima=35, ataque=3, ataqueEspecial=4, num='06' ){}	//truchi06

class Zumbat inherits 		TruchimonViento( saludMaxima=20, ataque=2, ataqueEspecial=2, num='17' ){}	//truchi17
class Spirrou inherits 		TruchimonViento( saludMaxima=15, ataque=2, ataqueEspecial=3, num='05' ){}	//truchi05

class Iivii inherits 		TruchimonNormal( saludMaxima=20, ataque=4, ataqueEspecial=4, num='08' ){	//truchi08
	override method movimientos() = super() + [barro]
	override method movimientosPosibles() = super() + [asado, bubuzela]
}		

class Miau inherits 		TruchimonNormal( saludMaxima=20, ataque=4, ataqueEspecial=4, num='14' ){	//truchi14
	override method movimientos() = super() + [tramontina]
	override method movimientosPosibles() = super() + [catarata, granizo]
}	
//[tacle, estrellita]  [trompada, fogon, mano, asado]  [trompada, mano, fogon, asado]
//8tipo, 3 x tipo=24
const tacle= 			new Movimiento(nombre='tacle'			,danioBase=5, tipo=normal)
const trompada= 		new Movimiento(nombre='trompada'		,danioBase=10,tipo=normal, 	id= 0)
const laManoDeDios= 	new Movimiento(nombre='la mano de Dios'	,danioBase=15,tipo=normal, 	id= 2)

const estrellita=		new Movimiento(nombre='estrellita'		,danioBase=5, tipo=fuego)
const fogon=			new Movimiento(nombre='fogon'			,danioBase=10,tipo=fuego,	id= 1)
const asado=			new Movimiento(nombre='asado'			,danioBase=15,tipo=fuego, 	id= 3)

const escupitajo = 		new Movimiento(nombre='escupitajo'		,danioBase=5, tipo=agua)
const sodazo = 			new Movimiento(nombre='sodazo'			,danioBase=10,tipo=agua,	id= 1)
const catarata = 		new Movimiento(nombre='catarata'		,danioBase=15,tipo=agua, 	id= 3)

const matecito = 		new Movimiento(nombre='matecito'		,danioBase=5, tipo=planta)
const fotosintesis =	new Movimiento(nombre='fotosintesis'	,danioBase=10,tipo=planta,	id= 1)
const pachamama = 		new Movimiento(nombre='pachamama'		,danioBase=15,tipo=planta, 	id= 3)

const barro = 			new Movimiento(nombre='barro'			,danioBase=5, tipo=tierra)
const pozo = 			new Movimiento(nombre='pozo'			,danioBase=10,tipo=tierra,	id= 1)
const zanja = 			new Movimiento(nombre='zanja'			,danioBase=15,tipo=tierra, 	id= 3)

const cubito = 			new Movimiento(nombre='cubito'			,danioBase=5, tipo=hielo)
const sambayon = 		new Movimiento(nombre='sambayon'		,danioBase=10,tipo=hielo,	id= 1)
const granizo = 		new Movimiento(nombre='granizo'			,danioBase=15,tipo=hielo, 	id= 3)

const tramontina = 		new Movimiento(nombre='tramontina'		,danioBase=5, tipo=metal)
const fierrazo = 		new Movimiento(nombre='fierrazo'		,danioBase=10,tipo=metal,	id= 1)
const cacerolazo = 		new Movimiento(nombre='cacerolazo'		,danioBase=15,tipo=metal, 	id= 3)

const flatulencia = 	new Movimiento(nombre='flatulencia'		,danioBase=5, tipo=viento, 	id= 1)
const eructo = 			new Movimiento(nombre='eructo'			,danioBase=10,tipo=viento,	id= 1)
const bubuzela = 		new Movimiento(nombre='bubuzela'		,danioBase=15,tipo=viento, 	id= 3)