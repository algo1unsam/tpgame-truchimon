import wollok.game.*

class Truchimon{
	const nombre=null  //o especie
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
	
	const movimientos = []
	const movimientosPosibles = []
	
	
	var property position = game.origin()
	
	const imagen = null
	
	method subeDeNivel(){
		if(nivelActual<self.nivel() and self.nivel()>3){
			nivelActual+=1
			//TODO:Hacer la seleccion del movimiento a olvidar, si se quiere aprender el nuevo
			self.olvidarUnMovimiento()
			self.aprenderMovimiento()
		}
	}
	
	method olvidarUnMovimiento(){
		//
	}
	
	
	method aprenderMovimiento(){//Aprende en base al indice del movimiento posible
		movimientos.add(movimientosPosibles.get(self.nivel()-1))
	}
	
	method nivel(){
		return (experiencia/100).roundUp()
	}
	
	
	
	method image(){
		return imagen
	}

	method atacar(truchimon,movimiento){ //Al atacar a otro truchimon hago que ejecute su metodo recibirAtaque
		truchimon.recibirAtaque(movimiento,self)
	}
	
	method recibirAtaque(movimiento,atacante){//Reduce la salud en base al danio generado por el ataque multiplicado por el factor de tipos
		salud = 0.max(salud-movimiento.danioEfectivo(atacante)*self.factorDeTipos(movimiento)+self.factorDeDefensa(movimiento))
	}
	
	method factorDeTipos(mov){ //Si soy resistente, el danio del ataque se reduce a la mitad, si soy debil es el doble y si no es ninguno, va directo.
		return if (self.soyResistente(mov)) 1/2 else if(self.soyDebil(mov)) 2 else 1
	}
	
	method soyResistente(mov){
		return tipo.resistencias().contains(mov.tipo())
	}
	
	method soyDebil(mov){
		return tipo.debilidades().contains(mov.tipo())
	}
	
	method factorDeDefensa(mov){//Determina si uso defensa o defensaEspecial
		return if(mov.tipo()==normal) defensa else defensaEspecial
	}
	
	method revivir(){
		salud=saludMaxima
	}
	
	method murio(){
		return salud==0
	}
	
}

class Movimiento {
	const property tipo=null
	const danioBase = null
	const imagen=null
	method danioEfectivo(truchimon){//dependiendo del tipo de ataque, uso el stat ataque o ataqueEspecial del truchimon
		return if(tipo==normal) danioBase + truchimon.ataque() else danioBase + truchimon.ataqueEspecial()
	}
	
	method image()=imagen
	
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
	
	
}

//Definicion de tipos
const fuego = new Tipo()
const agua = new Tipo()
const planta = new Tipo()
const normal = new Tipo()
const tierra = new Tipo()
const metal = new Tipo()
const viento = new Tipo()
const hielo = new Tipo()


//Ejemplos de Truchimones, porfa dejemoslos tipo easteregg
const verguigneo = new Truchimon(nombre='verguigneo',tipo=fuego,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10,imagen="Pokebola.jpg")
const bulbasaur = new Truchimon(nombre='bulbasaur',tipo=planta,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10,imagen="pixil-frame-0.png")
const mikali = new Truchimon(nombre='mikali',tipo=metal,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10,imagen="mikali.png")


//Truchimones posta, son presets, los personalizamos despues
const fuego1 = new Truchimon(/*TODO: nombrar cada uno al final*/tipo=fuego,/*TODO:ponerles stats al final*/movimientos=[tacle,estrellita],/*TODO:Agregar los movimientos posibles*/imagen=null )
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
const tacle= new Movimiento(danioBase=5,tipo=normal)
const trompada= new Movimiento(danioBase=10,tipo=normal)
const laManoDeDios= new Movimiento(danioBase=15,tipo=normal)

const estrellita=new Movimiento(danioBase=5,tipo=fuego)
const fogon=new Movimiento(danioBase=10,tipo=fuego)
const asado=new Movimiento(danioBase=15,tipo=fuego)

const garzo = new Movimiento(danioBase=5,tipo=agua)
const sodazo = new Movimiento(danioBase=10,tipo=agua)
const catarata = new Movimiento(danioBase=15,tipo=agua)

const yuyazo = new Movimiento(danioBase=5,tipo=planta)
const fotosintesis = new Movimiento(danioBase=10,tipo=planta)
const fasito = new Movimiento(danioBase=15,tipo=planta)

const barro = new Movimiento(danioBase=5,tipo=tierra)
const pozo = new Movimiento(danioBase=10,tipo=tierra)
const zanja = new Movimiento(danioBase=15,tipo=tierra)

const cubito = new Movimiento(danioBase=5,tipo=hielo)
const sambayon = new Movimiento(danioBase=10,tipo=hielo)
const granizo = new Movimiento(danioBase=15,tipo=hielo)

const tramontina = new Movimiento(danioBase=5,tipo=metal)
const fierrazo = new Movimiento(danioBase=10,tipo=metal)
const cacerolazo = new Movimiento(danioBase=15,tipo=metal)

const pedito = new Movimiento(danioBase=5,tipo=viento)
const eructo = new Movimiento(danioBase=10,tipo=viento)
const bubuzela = new Movimiento(danioBase=15,tipo=viento)





