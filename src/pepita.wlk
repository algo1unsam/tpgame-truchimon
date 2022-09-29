import wollok.game.*

object pepita {

	method position() = game.center()

	method image() = "pepita.png"

}
/** First Wollok example */
object wollok {
	method howAreYou() {
		return 'jajajas'
	}
}

class Truchimon{
	const nombre=null  //o especie
	const tipo = null //fuego,agua,etc
	var property salud = 0 //salud actual
	var saludMaxima = 20 //max health
	
	//Tema stats, 2 opciones: o cada stat es var por separado o usamos lista, cada indice es un stat dif
	//Stats por separado es mas claro para manipular, 
	//pero en vector podemos hacer cosas tipo maxstat o sumarlas
	

	method atacar(movimiento,truchimon){
		truchimon.recibirDanio(movimiento.danioEfectivo())
	}
	method recibirDanio(danio){
		salud -= danio
	}
	method revivir(){
		salud=saludMaxima
	}
	method estado(){
		return if(salud>0) "vivo" else "muerto"
	}
	
}

class Movimiento {
	const tipo=null
	const danio
	method danioEfectivo(){
		return danio
	}
	method efecto(){
		return "efecto"   //podriamos hacerlo con strings
	}
	
	
}







