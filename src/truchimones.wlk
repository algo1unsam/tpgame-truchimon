import wollok.game.*
import entrenador.*

class Truchimon{
	//Definicion de variables
	const property nombre=null  //o especie
	const tipo = null //fuego,agua,etc
	var saludMaxima = null //max health
	var property salud = saludMaxima //salud actual
	
	var property experiencia = 0
	
	var property ataque = null   //aniade danio al movimiento que use
	var property ataqueEspecial = null
	var property nivelActual = 1
	
	const property movimientos = []
	const movimientosPosibles = []
	
	
	var property position = game.origin() //Ver despues que hacer con la posicion en la jungla
	
	const imagen = null
	method image(){
		return imagen
	}
	
	
	//Logica de niveles y aprender movimientos
	method subeDeNivel(){
		if(nivelActual<self.nivel()){
			nivelActual+=1
			game.say(entrenador,self.nombre()+" subio a nivel "+nivelActual.toString())
			self.aumentoDeStats()
			if(self.noPuedeAprenderMovimiento()){//Si no puede aprender, olvida uno
				//TODO:Hacer la seleccion del movimiento a olvidar, si se quiere aprender el nuevo
				self.olvidarUnMovimiento()
			}
			self.aprenderMovimiento()
		}
	}
	
	method olvidarUnMovimiento(){
		const movimientoAOlvidar= movimientos.get(nivelActual - 5)
		movimientos.remove(movimientoAOlvidar)
		game.say(entrenador,self.nombre()+" ya esta grande para usar "+movimientoAOlvidar.nombre())
	}
	
	
	method aprenderMovimiento(){//Aprende en base al indice del movimiento posible
		const movimientoAAgregar = movimientosPosibles.get(nivelActual-1)
		movimientos.add(movimientoAAgregar)
		game.say(entrenador,"En su lugar, ahora aprendio a usar "+movimientoAAgregar.nombre())
	}
	
	method nivel(){//arrancan con nivel 1, hasta maximo 5!!
		return 5.max((experiencia/100).roundUp())
	}
	
	method ganarXP(){
		experiencia += 40
	}
	
	method noPuedeAprenderMovimiento(){//Puede tener hasta 4 movimientos
		return movimientos.size()==4
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

class Movimiento {
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
const verguigneo = new Truchimon(nombre='verguigneo',tipo=fuego,saludMaxima=20,ataque=10,ataqueEspecial=10,movimientos=[tacle,estrellita,trompada,fogon],imagen="Pokebola.jpg")
const bulbasaur = new Truchimon(nombre='bulbasaur',tipo=planta,saludMaxima=20,ataque=10,ataqueEspecial=10,movimientos=[tacle,matecito,trompada,fotosintesis],imagen="pixil-frame-0.png")
const mikali = new Truchimon(nombre='mikali',tipo=metal,saludMaxima=20,ataque=10,ataqueEspecial=10,imagen="mikali.png")


//Truchimones posta, son presets, los personalizamos despues
//Salud base 20
//Ataque base 4
//Ataque especial base = 4


const fuego1 = new Truchimon(nombre = 'drakeon',tipo=fuego,saludMaxima=20,ataque=3,ataqueEspecial=5,movimientos=[tacle,estrellita],movimientosPosibles=[trompada,fogon,laManoDeDios,asado],imagen=null )//truchi01
const fuego2 = new Truchimon(nombre='flamepony',tipo=fuego,saludMaxima=20,ataque=4,ataqueEspecial=5,movimientos=[tacle,estrellita],movimientosPosibles=[trompada,fogon,laManoDeDios,asado],imagen=null )//truchi15

const planta1 = new Truchimon(nombre='leafiny',tipo=planta,saludMaxima=20,ataque=4,ataqueEspecial=3,movimientos=[tacle,matecito],movimientosPosibles=[trompada,fotosintesis,laManoDeDios,pachamama],imagen=null )//truchi03
const planta2 = new Truchimon(nombre='wormlord',tipo=planta,saludMaxima=30,ataque=3,ataqueEspecial=1,movimientos=[tacle,matecito],movimientosPosibles=[trompada,fotosintesis,laManoDeDios,pachamama],imagen=null )//truchi07
const planta3 =new Truchimon(nombre='mongreen',tipo=planta,saludMaxima=20,ataque=4,ataqueEspecial=2,movimientos=[tacle,matecito],movimientosPosibles=[trompada,fotosintesis,laManoDeDios,pachamama],imagen=null )//truchi11

const agua1 = new Truchimon(nombre='surfyan',tipo=agua,saludMaxima=20,ataque=4,ataqueEspecial=4,movimientos=[tacle,escupitajo],movimientosPosibles=[trompada,sodazo,laManoDeDios,catarata],imagen=null )//truchi09
const agua2 = new Truchimon(nombre='mardel',tipo=agua,saludMaxima=20,ataque=4,ataqueEspecial=4,movimientos=[tacle,escupitajo],movimientosPosibles=[trompada,sodazo,laManoDeDios,catarata],imagen=null )//truchi16

const tierra1 = new Truchimon(nombre='rockball',tipo=tierra,saludMaxima=30,ataque=3,ataqueEspecial=4,movimientos=[tacle,barro],movimientosPosibles=[trompada,pozo,laManoDeDios,zanja],imagen=null )//truchi19
const tierra2 = new Truchimon(nombre='mudtail',tipo=tierra,saludMaxima=35,ataque=3,ataqueEspecial=3,movimientos=[tacle,barro],movimientosPosibles=[trompada,pozo,laManoDeDios,zanja],imagen=null )//truchi02

const metal1 = new Truchimon(nombre='metetal',tipo=metal,saludMaxima=15,ataque=4,ataqueEspecial=6,movimientos=[tacle,tramontina],movimientosPosibles=[trompada,fierrazo,laManoDeDios,cacerolazo],imagen=null )//truchi18
const metal2 = new Truchimon(nombre='dotal',tipo=metal,saludMaxima=15,ataque=4,ataqueEspecial=6,movimientos=[tacle,tramontina],movimientosPosibles=[trompada,fierrazo,laManoDeDios,cacerolazo],imagen=null )//truchi21

const hielo1 = new Truchimon(nombre='snowflake',tipo=hielo,saludMaxima=30,ataque=4,ataqueEspecial=4,movimientos=[tacle,cubito],movimientosPosibles=[trompada,sambayon,laManoDeDios,granizo],imagen=null )//truchi13
const hielo2 = new Truchimon(nombre='icyclaws',tipo=hielo,saludMaxima=35,ataque=3,ataqueEspecial=4,movimientos=[tacle,cubito],movimientosPosibles=[trompada,sambayon,laManoDeDios,granizo],imagen=null )//truchi06

const viento1 = new Truchimon(nombre='namtab',tipo=viento,saludMaxima=20,ataque=2,ataqueEspecial=2,movimientos=[tacle,pedito],movimientosPosibles=[trompada,eructo,laManoDeDios,bubuzela],imagen=null )//truchi17
const viento2 = new Truchimon(nombre='caslamon',tipo=viento,saludMaxima=15,ataque=2,ataqueEspecial=3,movimientos=[tacle,pedito],movimientosPosibles=[trompada,eructo,laManoDeDios,bubuzela],imagen=null )//truchi20

const normal1 = new Truchimon(nombre='iivii',tipo=normal,saludMaxima=20,ataque=4,ataqueEspecial=4,movimientos=[tacle],movimientosPosibles=[trompada,laManoDeDios,asado,bubuzela],imagen=null )//truchi08
const normal2 = new Truchimon(nombre='toga',tipo=normal,saludMaxima=20,ataque=4,ataqueEspecial=4,movimientos=[tacle],movimientosPosibles=[trompada,laManoDeDios,catarata,cacerolazo],imagen=null )//truchi14




//8tipo, 3 x tipo=24
const tacle= new Movimiento(nombre="tacle",danioBase=5,tipo=normal)
const trompada= new Movimiento(nombre="trompada",danioBase=10,tipo=normal)
const laManoDeDios= new Movimiento(nombre='laManoDeDios',danioBase=15,tipo=normal)

const estrellita=new Movimiento(nombre='estrellita',danioBase=5,tipo=fuego)
const fogon=new Movimiento(nombre='fogon',danioBase=10,tipo=fuego)
const asado=new Movimiento(nombre='asado',danioBase=15,tipo=fuego)

const escupitajo = new Movimiento(nombre='escupitajo',danioBase=5,tipo=agua)
const sodazo = new Movimiento(nombre='sodazo',danioBase=10,tipo=agua)
const catarata = new Movimiento(nombre='catarata',danioBase=15,tipo=agua)

const matecito = new Movimiento(nombre = 'matecito',danioBase=5,tipo=planta)
const fotosintesis = new Movimiento(nombre='fotosintesis',danioBase=10,tipo=planta)
const pachamama = new Movimiento(nombre='pachamama',danioBase=15,tipo=planta)

const barro = new Movimiento(nombre='barro',danioBase=5,tipo=tierra)
const pozo = new Movimiento(nombre='pozo',danioBase=10,tipo=tierra)
const zanja = new Movimiento(nombre='zanja',danioBase=15,tipo=tierra)

const cubito = new Movimiento(nombre='cubito',danioBase=5,tipo=hielo)
const sambayon = new Movimiento(nombre='sambayon',danioBase=10,tipo=hielo)
const granizo = new Movimiento(nombre='granizo',danioBase=15,tipo=hielo)

const tramontina = new Movimiento(nombre='tramontina',danioBase=5,tipo=metal)
const fierrazo = new Movimiento(nombre='fierrazo',danioBase=10,tipo=metal)
const cacerolazo = new Movimiento(nombre='cacerolazo',danioBase=15,tipo=metal)

const pedito = new Movimiento(nombre='pedito',danioBase=5,tipo=viento)
const eructo = new Movimiento(nombre='eructo',danioBase=10,tipo=viento)
const bubuzela = new Movimiento(nombre='bubuzela',danioBase=15,tipo=viento)






