import wollok.game.*

class Truchimon{
	const nombre=null  //o especie
	const tipo = null //fuego,agua,etc
	var property salud = saludMaxima //salud actual
	var saludMaxima = null //max health
	var property ataque = null   //aniade danio al movimiento que use
	var property defensa = null  //resta danio recibido 
	var property velocidad = null
	var property ataqueEspecial = null
	var property defensaEspecial = null
	

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
	
	method estado(){
		return if(salud>0) "vivo" else "muerto"
	}
	
}

class Movimiento {
	const property tipo=null
	const danioBase = null
	method danioEfectivo(truchimon){//dependiendo del tipo de ataque, uso el stat ataque o ataqueEspecial del truchimon
		return if(tipo==normal) danioBase + truchimon.ataque() else danioBase + truchimon.ataqueEspecial()
	}
}

class Tipo{
	var property debilidades = []
	var property resistencias = []
	
}
const fuego = new Tipo()
const agua = new Tipo(resistencias=[fuego])
const planta = new Tipo(debilidades=[fuego],resistencias=[agua])
const normal = new Tipo()

const charmander = new Truchimon(nombre='charmander',tipo=fuego,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10)
const bulbasaur = new Truchimon(nombre='bulbasaur',tipo=planta,saludMaxima=20,ataque=10,defensa=10,velocidad=10,ataqueEspecial=10,defensaEspecial=10)

const tacle= new Movimiento(danioBase=5,tipo=normal)
const asado=new Movimiento(danioBase=5,tipo=fuego)







