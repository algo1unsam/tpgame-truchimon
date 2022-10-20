import wollok.game.*

class Truchimon{
	//Definicion de variables
	const property nombre=null  //o especie
	const tipo = null //fuego,agua,etc
	var saludMaxima = null //max health
	var property salud = saludMaxima //salud actual
	
	var property experiencia = 0
	
	var property ataque = null   //aniade danio al movimiento que use
	var property defensa = null  //resta danio recibido 
	var property velocidad = null
	var property ataqueEspecial = null
	var property defensaEspecial = null
	var property nivelActual = 1
	
	const property movimientos = []
	const movimientosPosibles = []
	var movimientoAOlvidar = null
	
	
	var property position = game.origin() //Ver despues que hacer con la posicion en la jungla
	
	const imagen = null
	method image(){
		return imagen
	}
	
	
	//Logica de niveles y aprender movimientos
	method subeDeNivel(){
		if(nivelActual<self.nivel()){
			nivelActual+=1
			//Mostrar movimiento posible con movimientosPosibles.get(self.nivel()-1)
			//Que elija si lo quiere o no
			if(true){//En caso de que si
				if(self.noPuedeAprenderMovimiento()){//Si no puede aprender, olvida uno
					//TODO:Hacer la seleccion del movimiento a olvidar, si se quiere aprender el nuevo
					self.olvidarUnMovimiento()
				}
				self.aprenderMovimiento()
			}
			self.aumentoDeStats()
		}
			
					
		
	}
	
	method olvidarUnMovimiento(){
		//TODO: definir el movimiento a olvidar
		movimientos.remove(movimientoAOlvidar)
	}
	
	
	method aprenderMovimiento(){//Aprende en base al indice del movimiento posible
		movimientos.add(movimientosPosibles.get(self.nivel()-1))
	}
	
	method nivel(){//arrancan con nivel 1, hasta maximo 5!!
		return 5.max((experiencia/100).roundUp())
	}
	
	method noPuedeAprenderMovimiento(){//Puede tener hasta 4 movimientos
		return movimientos.size()==4
	}
	
	method aumentoDeStats(){
		//TODO: que tanto aumentan, si todos igual o no. Lo ideal seria que dependa del tipo del truchimon
	}
	
	
	
	
	//Dinamicas ataques
	method atacar(truchimon,movimiento){ //Al atacar a otro truchimon hago que ejecute su metodo recibirAtaque
		truchimon.recibirAtaque(movimiento,self)
		
		if(tipo.esPlanta() and movimiento.esTipoPlanta()){
			self.curarse(truchimon,movimiento)
		}
		
		
		
	}
	
	method recibirAtaque(movimiento,atacante){//Reduce la salud en base al danio generado por el ataque multiplicado por el factor de tipos
		salud = 0.max(salud - self.danioRecibido(movimiento,atacante))
	}
	
	method danioRecibido(movimiento,atacante){
		return movimiento.danioEfectivo(atacante)*self.factorDeTipos(movimiento)//-self.factorDeDefensa(movimiento)
	}
	
	method factorDeTipos(mov){ //Si soy resistente, el danio del ataque se reduce a la mitad, si soy debil es el doble y si no es ninguno, va directo.
		return if (tipo.soyResistenteA(mov)) 1/2 else if(tipo.soyDebilA(mov)) 2 else 1
	}
	
	method factorDeDefensa(mov){//Determina si uso defensa o defensaEspecial
		//return if(mov.tipo()==normal) defensa else defensaEspecial
		return mov.tipo().factorDeDefensa(self)
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
	method factorDeDefensa(defensor){
		return defensor.defensaEspecial()
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
	
}

object normal inherits Tipo{
	override method factorDeDefensa(defensor){
		return defensor.defensa()
	}
	override method factorDeAtaque(atacante){
		return atacante.ataque()
	}
}


object planta inherits Tipo{
	
	override method esPlanta(){
		return true
	}
	
}


//Definicion de tipos
const fuego = new Tipo()
const agua = new Tipo()
//const planta = new Tipo()
//const normal = new Tipo()
const tierra = new Tipo()
const metal = new Tipo()
const viento = new Tipo()
const hielo = new Tipo()

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
const verguigneo = new Truchimon(nombre='verguigneo',tipo=fuego,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10,movimientos=[tacle,estrellita,trompada,fogon],imagen="Pokebola.jpg")
const bulbasaur = new Truchimon(nombre='bulbasaur',tipo=planta,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10,movimientos=[tacle,yuyazo,trompada,fotosintesis],imagen="pixil-frame-0.png")
const mikali = new Truchimon(nombre='mikali',tipo=metal,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10,imagen="mikali.png")


//Truchimones posta, son presets, los personalizamos despues
const fuego1 = new Truchimon(nombre = 'drakeon',tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,estrellita],/*TODO:Agregar los movimientos posibles*/imagen=null )
const fuego2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,estrellita],/*TODO:Agregar los movimientos posibles*/imagen=null )

const planta1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,yuyazo],/*TODO:Agregar los movimientos posibles*/imagen=null )
const planta2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,yuyazo],/*TODO:Agregar los movimientos posibles*/imagen=null )

const agua1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,garzo],/*TODO:Agregar los movimientos posibles*/imagen=null )
const agua2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,garzo],/*TODO:Agregar los movimientos posibles*/imagen=null )

const tierra1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,barro],/*TODO:Agregar los movimientos posibles*/imagen=null )
const tierra2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,barro],/*TODO:Agregar los movimientos posibles*/imagen=null )

const metal1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,tramontina],/*TODO:Agregar los movimientos posibles*/imagen=null )
const metal2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,tramontina],/*TODO:Agregar los movimientos posibles*/imagen=null )

const hielo1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,cubito],/*TODO:Agregar los movimientos posibles*/imagen=null )
const hielo2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,cubito],/*TODO:Agregar los movimientos posibles*/imagen=null )

const viento1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,pedito],/*TODO:Agregar los movimientos posibles*/imagen=null )
const viento2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,pedito],/*TODO:Agregar los movimientos posibles*/imagen=null )

const normal1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle],/*TODO:Agregar los movimientos posibles*/imagen=null )
const normal2 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle],/*TODO:Agregar los movimientos posibles*/imagen=null )




//8tipo, 3 x tipo=24
const tacle= new Movimiento(nombre="tacle",danioBase=5,tipo=normal)
const trompada= new Movimiento(nombre="trompada",danioBase=10,tipo=normal)
const laManoDeDios= new Movimiento(nombre='laManoDeDios',danioBase=15,tipo=normal)

const estrellita=new Movimiento(nombre='estrellita',danioBase=5,tipo=fuego)
const fogon=new Movimiento(nombre='fogon',danioBase=10,tipo=fuego)
const asado=new Movimiento(nombre='asado',danioBase=15,tipo=fuego)

const garzo = new Movimiento(nombre='garzo',danioBase=5,tipo=agua)
const sodazo = new Movimiento(nombre='sodazo',danioBase=10,tipo=agua)
const catarata = new Movimiento(nombre='catarata',danioBase=15,tipo=agua)

const yuyazo = new Movimiento(nombre = 'yuyazo',danioBase=5,tipo=planta)
const fotosintesis = new Movimiento(nombre='fotosintesis',danioBase=10,tipo=planta)
const fasito = new Movimiento(nombre='fasito',danioBase=15,tipo=planta)

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






