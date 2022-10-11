import wollok.game.*
import config.*
import entrenador.*
import jungla.*

class Estructura {}

object hospital inherits Estructura {
	method position() = game.at(7, 0)

	method image() = "hospital.png"
}

object jungla inherits Estructura {
	method position() = game.at(0, 7)

	method image() = "jungla.png"
}

object coliseo inherits Estructura {
	method position() = game.at(14, 7)

	method image() = "jungla.png" // TODO: cambiar visual
}


class Escenario {	
	method iniciar() {
		config.run()
	}
}

object intro inherits Escenario {
	override method iniciar() {
		super()
		game.addVisualIn(backgnd,game.at(0,3))
		game.addVisualIn(text,game.origin())
		
		keyboard.num1().onPressDo{
			config.agregarStarter(planta)
		}
		keyboard.num2().onPressDo{
			config.agregarStarter(agua)
		}
		keyboard.num3().onPressDo{
			config.agregarStarter(fuego)
		}
		
		game.start()
	}
}

object principal inherits Escenario {
	override method iniciar() {
		super()
		const bosque01 = new Bosque()
		//bosque01.agregarArbol(0,0,0)
		//bosque01.agregarArbol(0,5,0)
		
		game.ground('pasto.png')
		game.addVisual(entrenador)
		//game.addVisual(hospital)
		//game.addVisual(jungla)
		//game.addVisual(coliseo)
		game.addVisual(new Arbol(index=0,x_pos=0,y_pos=0))
		game.addVisual(new Arbol(index=0,x_pos=1,y_pos=0))
		
		entrenador.starter(config.starter())
		
		keyboard.right().onPressDo{entrenador.moverR()}
		keyboard.left().onPressDo{entrenador.moverL()}
		keyboard.up().onPressDo{entrenador.moverU()}
		keyboard.down().onPressDo{entrenador.moverD()}
	}
}

object backgnd {
	method image() = "bkgnStarter.jpeg"
} 

object text {
	method image() = "starterOptions.png"
} 