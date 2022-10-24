import wollok.game.*
import config.*
import entrenador.*
import jungla.*
import truchimones.*

class Estructura {}

object fondo {
	method image() = 'mapas.png'
	method position() = game.origin()
}

object matrices{
	method generar(xmin,xmax,ymin,ymax,nocollide){
		const bloques = []
		(ymin..ymax).forEach({y=>(xmin..xmax).forEach({x=>bloques.add(new Position(x=x,y=y))})})
		bloques.removeAll(nocollide)
		return bloques	
	}
	
}


object hospital inherits Estructura {	
	const nocollide = [new Position(x=17,y=9),new Position(x=18,y=9),new Position(x=19,y=9),new Position(x=18,y=10)]
	const property bloques = matrices.generar(15,21,9,12,nocollide)
	/*[
		[15, 12],[16, 12],[17, 12], [18, 12], [19, 12],[20, 12], [21, 12],
		[15, 11],[16, 11],[17, 11], [18, 11], [19, 11],[20, 11], [21, 11],
		[15, 10],[16, 10],[17, 10], [19, 10] ,[20, 10], [21, 10],
		[15, 9], [16, 9], [20, 9], [21, 9]
		
	]*/
	const property entrada = new Position(x=18,y=10)

}

object lago inherits Estructura {	
	const nocollide = [new Position(x=21,y=6),new Position(x=21,y=5),new Position(x=21,y=4)]
	const property bloques = matrices.generar(17,23,4,6,nocollide)
	/*[
		[17, 6],[18, 6],[19, 6],[20, 6],[22, 6],[23, 6],
		[17, 5],[18, 5],[19, 5],[20, 5],[22, 5],[23, 5],
		[17, 4],[18, 4],[19, 4],[20, 4],[22, 4],[23, 4]
	]*/
		
	const property entrada = []
}

object casarandom inherits Estructura {	
	const property bloques = matrices.generar(2,8,3,7,[])
	
//	const property bloques = [
//		[2, 7],[3, 7],[4, 7],[5, 7],[6, 7],[7, 7],[8, 7],
//		[2, 6],[3, 6],[4, 6],[5, 6],[6, 6],[7, 6],[8, 6],
//		[2, 5],[3, 5],[4, 5],[5, 5],[6, 5],[7, 5],[8, 5],
//		[2, 4],[3, 4],[4, 4],[5, 4],[6, 4],[7, 4],[8, 4],
//		[2, 3],[3, 3],[4, 3],[5, 3],[6, 3],[7, 3],[8, 3]
//	]
	
	const property entrada = []

}

object bosque inherits Estructura {
	const b1 = matrices.generar(3,8,0,1,[])
	const b2 = matrices.generar(12,17,0,1,[])
	const property bloques = b1+b2
	
	const property entrada = []
}

object jungla inherits Estructura {
	const b1 = matrices.generar(0,3,9,9,[])
	const b2 = matrices.generar(3,3,11,13,[])
	var property bloques = b1+b2
	/*[
		[0, 9],[1, 9],[2, 9],[3, 9],[3, 11],[3, 12],[3, 13]
	]*/
	const property entrada = []
	
	method position() = game.at(0, 7)

	method image() = "jungla.png"
}

object coliseo inherits Estructura {
	const property bloques = []
	
	const property entrada = new Position(x=5,y=13)
	
	//method position() = game.at(14, 7)

	method image() = "jungla.png" // TODO: cambiar visual
}



class BloqueDummy {
	var property position

	method image() = "vacio.png"
}

class BloqueEntrada {
	var property position

	method image() = "vacio.png"
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
		game.addVisualIn(backgnd,game.origin())
		game.addVisualIn(text,game.at(7,0))
		
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
		game.addVisual(fondo)

		game.addVisualCharacter(entrenador)
		self.crearBordes()
		
		//game.addVisual(bulbasaur)
		
		entrenador.starter(config.starter())
		
		keyboard.right().onPressDo{entrenador.moverR()}
		keyboard.left().onPressDo{entrenador.moverL()}
		keyboard.up().onPressDo{entrenador.moverU()}
		keyboard.down().onPressDo{entrenador.moverD()}
	}
	
	override method crearBordes() {
		// TODO: Eliminar mensaje cuando colisiona? Ver en entrenador.wlk
		[hospital, casarandom, lago, jungla, bosque, coliseo].flatMap{ escena => escena.bloques()}.forEach{
			bloque => game.addVisual(
				new BloqueDummy(position = bloque)
			)
		}
		// TODO: Cambiar a la escena correspondiente. Editar BloqueEntrada
		[hospital, coliseo].map{ escena => escena.entrada()}.forEach{
			entrada => game.addVisual(
				new BloqueEntrada(position = entrada)
			)
		}
	}
}

object junglaModo inherits Escenario {
	override method iniciar() {
		config.cambiarEscenario(self)
		super()
		game.ground('pasto_jungla.png')
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
}

object backgnd {
	method image() = "bgStarter.png"
} 

object text {
	method image() = "starterOptions.png"
} 