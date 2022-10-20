import wollok.game.*
import config.*
import entrenador.*
import jungla.*
import truchimones.*

class Estructura {}

object hospital inherits Estructura {	
	const property bloques = [
		[7, 0], [7, 1], [7, 2], [7, 3], [7, 4],
		[8, 4], [9, 4], [10, 4], [13, 4], [14, 4], [15, 4], [16, 4],
		[16, 0], [16, 1], [16, 2], [16, 3], [16, 4]
	]
	const property entrada = [[11, 4], [12, 4]]
	
	method position() = game.at(7, 0)

	method image() = "hospital.png"
}

object jungla inherits Estructura {
	const property bloques = [
		[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7],
		[9, 7], [9, 9], [9, 10], [9, 11]
	]
	const property entrada = [[9, 8]]
	
	method position() = game.at(0, 7)

	method image() = "jungla.png"
}

object coliseo inherits Estructura {
	const property bloques = [
		[15, 7], [16, 7], [17, 7], [18, 7], [19, 7], [20, 7], [21, 7], [22, 7], [23, 7],
		[14, 7], [14, 9], [14, 10], [14, 11]
	]
	const property entrada = [[14, 8]]
	
	method position() = game.at(14, 7)

	method image() = "jungla.png" // TODO: cambiar visual
}

class BloqueDummy {
	var property position

	method image() = "dummy.png"
}

class BloqueEntrada {
	var property position

	method image() = "entrada.png"
}

class Escenario {	
	method iniciar() {
		config.run()
	}
	
	method crearBordes() {}
	
	method removerObjetos() {}
}

object intro inherits Escenario {
	override method iniciar() {
		super()
		game.ground('pasto.png')
		game.addVisualIn(backgnd,game.origin())
		game.addVisualIn(text,game.at(7,1))
		
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
	const property listaBloques = [] 
	
	override method iniciar() {
		super()
		game.ground('pasto.png')
		game.addVisual(hospital)
		game.addVisual(jungla)
		game.addVisual(coliseo)
		game.addVisualCharacter(entrenador)
		self.crearBordes()
		game.addVisual(new Arbol(index=0,x_pos=0,y_pos=0))
		game.addVisual(new Arbol(index=0,x_pos=1,y_pos=0))
		
		entrenador.starter(config.starter())
		
		keyboard.right().onPressDo{entrenador.moverR()}
		keyboard.left().onPressDo{entrenador.moverL()}
		keyboard.up().onPressDo{entrenador.moverU()}
		keyboard.down().onPressDo{entrenador.moverD()}
	}
	
	override method crearBordes() {
		// TODO: Eliminar mensaje cuando colisiona? Ver en entrenador.wlk
		[hospital, jungla, coliseo].flatMap{ escena => escena.bloques()}.forEach{
			bloque => game.addVisual(
				new BloqueDummy(position = game.at(bloque.get(0), bloque.get(1)))
			)
		}
		// TODO: Cambiar a la escena correspondiente. Editar BloqueEntrada
		[hospital, jungla, coliseo].flatMap{ escena => escena.entrada()}.forEach{
			entrada => game.addVisual(
				new BloqueEntrada(position = game.at(entrada.get(0), entrada.get(1)))
			)
		}
	}
}

object junglaModo inherits Escenario {
	const property truchimones = []
	
	override method iniciar() {
		config.cambiarEscenario(mensajes.junglaName())
		super()
		game.addVisualCharacter(entrenador)
		self.crearBordes()
		
		entrenador.starter(config.starter())
		
		keyboard.right().onPressDo{entrenador.moverR()}
		keyboard.left().onPressDo{entrenador.moverL()}
		keyboard.up().onPressDo{entrenador.moverU()}
		keyboard.down().onPressDo{entrenador.moverD()}
	}
	
	override method crearBordes() {
		// TODO: Crear salida
	}
	
	method generarTruchimones() {
		
	}
}

object backgnd {
	method image() = "bgStarter.png"
} 

object text {
	method image() = "starterOptions.png"
} 