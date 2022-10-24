import wollok.game.*
import entrenador.*

class Truchimon{
	//Definicion de variables
	//var property nombre  									<- esta al pedo
	const tipo = null 										// fuego, agua, etc
	var saludMaxima = null 									// max health
	var property salud = saludMaxima 						// salud actual
	var property estado = salvaje							// identifica si tiene o no dueño	
	var property ataque = null   							// Añade Daño al movimiento que use
	var property ataqueEspecial = null
	var property nivelActual = 1
	var property experiencia = 0
		
	const movimientos = []
	const movimientosPosibles = []
	const maxMovimientos = 4
	var property position = game.origin() 					// Ver despues que hacer con la posicion en la jungla
	
	const property num = null 								// Numero del tipo -> truchif{01}.png siendo el nro el valor entre {}
		
	method movimientosBase() = [tacle]
	method movimientosPosibles() = [trompada, laManoDeDios]
	method movimientos() = self.movimientosBase() + movimientos
	
	method nombre() = self.printString()
	// Aprende el siguiente en la lista de posibles según su nivel
	
	method aprenderMovimiento(){
		const movimientoMejorado = movimientosPosibles.get(nivelActual-1)		
		if (!self.puedoAprender()) { self.olvidarUnMovimiento() } // si no puedo aprender borro el obsoleto 
		movimientos.add(movimientoMejorado)		
		game.say(entrenador, self.printString() + " aprendió a usar " + movimientoMejorado.printString())
	}
	
	method olvidarUnMovimiento(){
		const movimientoObsoleto = movimientos.first()
		movimientos.remove(movimientoObsoleto)
		game.say(entrenador, self.toString() + " olvidó " + movimientoObsoleto.toString())
	}
	
	method puedoAprender() = (maxMovimientos < movimientos.size())
	
	method expPorLevel() = 100*1.5**(nivelActual+1)
	
	// Retorna el Valor del png necesario para la imagen
	method image() = ('truchi' + self.perfilPoke() + num + '.png') 
	
	// La imagen debe mostrarse en pantalla de frente, izq o derecha en base al estado del truchi
	method perfilPoke() = estado.perfilPoke()
			
	//Logica de niveles y aprender movimientos
	method subeDeNivel(){
		if( experiencia >= self.expPorLevel() and nivelActual < 5 ){
			nivelActual += 1
			game.say(entrenador, self.printString() + " subio a nivel -> " + nivelActual.toString())
			self.aumentoDeStats()
			self.aprenderMovimiento()
		}
	}	
	
	method ganarXP(){
		experiencia += 40
	}
	
	method aumentoDeStats(){
		//TODO: que tanto aumentan, si todos igual o no. Lo ideal seria que dependa del tipo del truchimon
		saludMaxima += 15
		ataque += nivelActual-1
		ataqueEspecial += nivelActual -1 	
	}	
	
	//Dinamicas ataques
	method atacar(truchimon,movimiento){ //Al atacar a otro truchimon hago que ejecute su metodo recibirAtaque
		if (not truchimon.puedeEsquivar()){
			truchimon.recibirAtaque(movimiento,self)
			if(tipo.esPlanta() and movimiento.esTipoPlanta()){
				self.curarse(truchimon,movimiento)
			}
		}
	}
	
	method recibirAtaque(movimiento,atacante){//Reduce la salud en base al danio generado por el ataque multiplicado por el factor de tipos
		salud = 0.max(salud - self.danioRecibido(movimiento,atacante))
	}
	
	method danioRecibido(movimiento,atacante){
		return movimiento.danioEfectivo(atacante)*self.factorDeTipos(movimiento)
	}
	
	method factorDeTipos(mov){ //Si soy resistente, el danio del ataque se reduce a la mitad, si soy debil es el doble y si no es ninguno, va directo.
		return if (tipo.soyResistenteA(mov)) 1/2 else if(tipo.soyDebilA(mov)) 2 else 1
	}	
	
	method curarse(truchimon,movimiento){
		salud = saludMaxima.min(salud + truchimon.danioRecibido(movimiento,self)/2)
	}
	
	method revivir(){
		salud=saludMaxima
	}
	
	method murio(){//Siento que conviene para armar las batallas
		return salud==0
	}
	
	method puedeEsquivar(){
		return tipo.puedeEsquivar()
	}	
}

class TruchimonFuego inherits Truchimon{
	override method movimientosBase() = super() + [estrellita]
	override method movimientosPosibles() = super() + [fogon, asado]
}

class TruchimonPlanta inherits Truchimon{
	override method movimientosBase() = super() + [matecito]
	override method movimientosPosibles() = super() + [fotosintesis, pachamama]
}

class TruchimonAgua inherits Truchimon{
	override method movimientosBase() = super() + [escupitajo]
	override method movimientosPosibles() = super() + [sodazo, catarata]
}

class TruchimonTierra inherits Truchimon{
	override method movimientosBase() = super() + [barro]
	override method movimientosPosibles() = super() + [pozo, zanja]
}
class TruchimonMetal inherits Truchimon{
	override method movimientosBase() = super() + [tramontina]
	override method movimientosPosibles() = super() + [fierrazo, cacerolazo]
}

class TruchimonHielo inherits Truchimon{
	override method movimientosBase() = super() + [cubito]
	override method movimientosPosibles() = super() + [sambayon, granizo]
}

class TruchimonViento inherits Truchimon{
	override method movimientosBase() = super() + [flatulencia]
	override method movimientosPosibles() = super() + [eructo, bubuzela]
}

class Movimiento {
	const property index = null
	const property nombre = null
	const property tipo=null
	const danioBase = null
	const imagen=null
	method danioEfectivo(truchimon){//dependiendo del tipo de ataque, uso el stat ataque o ataqueEspecial del truchimon
		return danioBase + tipo.factorDeAtaque(truchimon)
	}
	
	method image()=imagen //Para poder mostrar los ataques que uno tiene, wollok no tiene buen texto 
	
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
	
	method puedeEsquivar(){
		const proba = 1.randomUpTo(100)
		return proba < 10
	}
	
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

object viento inherits Tipo{
	
	override method puedeEsquivar(){
		const proba = 1.randomUpTo(100)
		return proba < 25
	}
}

object hielo inherits Tipo{
	
	override method puedeEsquivar(){
		const proba = 1.randomUpTo(100)
		return proba < 15
	}
}


//Definicion de tipos
const fuego = new Tipo() //Mas ataque especial menos ataque R3D3
const agua = new Tipo() //Mas equilibrado R2D2
//const planta = new Tipo() //Menos ataque especial Se regenera R2D4
//const normal = new Tipo() //Equilibradonada R0D0 al principio es re verga pero al final aprende los ataques re poderosos tipo comodin
const tierra = new Tipo() //Mas salud++ menos ataque R1D3
const metal = new Tipo() //Mas ataque++ menos salud R3D2
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


class Charmilion inherits  	TruchimonFuego ( tipo=fuego, 	saludMaxima=20, ataque=3, ataqueEspecial=5, num=01 ){}	//truchi01
class Ponita inherits  		TruchimonFuego ( tipo=fuego,	saludMaxima=20, ataque=4, ataqueEspecial=5, num=15 ){}	//truchi15

class Lifeon inherits 		TruchimonPlanta( tipo=planta,	saludMaxima=20,	ataque=4, ataqueEspecial=3, num=03 ){}	//truchi03
class Medestapod inherits 	TruchimonPlanta( tipo=planta,	saludMaxima=30,	ataque=3, ataqueEspecial=1, num=07 ){}	//truchi07
class Grukey inherits 		TruchimonPlanta( tipo=planta,	saludMaxima=20,	ataque=4, ataqueEspecial=2,	num=11 ){}	//truchi11

class Jorsi inherits 		TruchimonAgua  ( tipo=agua,		saludMaxima=20,	ataque=4, ataqueEspecial=4, num=09 ){}	//truchi09
class Sil inherits 			TruchimonAgua  ( tipo=agua,		saludMaxima=20,	ataque=4, ataqueEspecial=4, num=16 ){}	//truchi16

class Jeodud inherits 		TruchimonTierra( tipo=tierra,	saludMaxima=30,	ataque=3, ataqueEspecial=4, num=19 ){}	//truchi19
class Umbrion inherits 		TruchimonTierra( tipo=tierra,	saludMaxima=35,	ataque=3, ataqueEspecial=3, num=02 ){}	//truchi02

class Magnemait inherits 	TruchimonMetal ( tipo=metal,	saludMaxima=15,	ataque=4, ataqueEspecial=6, num=18 ){}	//truchi18
class Aaron inherits 		TruchimonMetal ( tipo=metal,	saludMaxima=15,	ataque=4, ataqueEspecial=6, num=21 ){}	//truchi21

class Glacion inherits 		TruchimonHielo ( tipo=hielo,	saludMaxima=30,	ataque=4, ataqueEspecial=4, num=13){}	//truchi13
class Wivil inherits 		TruchimonHielo ( tipo=hielo,	saludMaxima=35,	ataque=3, ataqueEspecial=4, num=06){}	//truchi06

class Zumbat inherits 		TruchimonViento( tipo=viento,	saludMaxima=20,	ataque=2, ataqueEspecial=2, num=17){}	//truchi17
class Spirrou inherits 		TruchimonViento( tipo=viento,	saludMaxima=15,	ataque=2, ataqueEspecial=3, num=20){}	//truchi20

class Iivii inherits 		Truchimon      ( tipo=normal,	saludMaxima=20,	ataque=4, ataqueEspecial=4, num=08, movimientosPosibles=[asado, bubuzela]){}		//truchi08
class Miau inherits 		Truchimon      ( tipo=normal,	saludMaxima=20,	ataque=4, ataqueEspecial=4, num=14, movimientosPosibles=[catarata, cacerolazo]){}	//truchi14

//8tipo, 3 x tipo=24
const tacle= 			new Movimiento(danioBase=5,	tipo=normal, index= 0)
const trompada= 		new Movimiento(danioBase=10,tipo=normal, index= 2)
const laManoDeDios= 	new Movimiento(danioBase=15,tipo=normal, index= 4)

const estrellita=		new Movimiento(danioBase=5,	tipo=fuego)
const fogon=			new Movimiento(danioBase=10,tipo=fuego)
const asado=			new Movimiento(danioBase=15,tipo=fuego, index= 5)

const escupitajo = 		new Movimiento(danioBase=5,	tipo=agua, index= 1)
const sodazo = 			new Movimiento(danioBase=10,tipo=agua)
const catarata = 		new Movimiento(danioBase=15,tipo=agua, index= 5)

const matecito = 		new Movimiento(danioBase=5,	tipo=planta, index= 1)
const fotosintesis =	new Movimiento(danioBase=10,tipo=planta)
const pachamama = 		new Movimiento(danioBase=15,tipo=planta, index= 5)

const barro = 			new Movimiento(danioBase=5,	tipo=tierra, index= 1)
const pozo = 			new Movimiento(danioBase=10,tipo=tierra)
const zanja = 			new Movimiento(danioBase=15,tipo=tierra, index= 5)

const cubito = 			new Movimiento(danioBase=5,	tipo=hielo, index= 1)
const sambayon = 		new Movimiento(danioBase=10,tipo=hielo)
const granizo = 		new Movimiento(danioBase=15,tipo=hielo, index= 5)

const tramontina = 		new Movimiento(danioBase=5,	tipo=metal, index= 1)
const fierrazo = 		new Movimiento(danioBase=10,tipo=metal)
const cacerolazo = 		new Movimiento(danioBase=15,tipo=metal, index= 5)

const flatulencia = 	new Movimiento(danioBase=5,	tipo=viento, index= 1)
const eructo = 			new Movimiento(danioBase=10,tipo=viento)
const bubuzela = 		new Movimiento(danioBase=15,tipo=viento, index= 5)






