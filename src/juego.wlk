import wollok.game.*
import entrenador.*
import eleccionCredo.*

object juego {
	
	method iniciar(starter){
		
		game.clear()
		game.width(13)
		game.height(10)
		game.title("Truchimon")
		game.addVisual(entrenador)
		
		entrenador.starter(starter)
		
		keyboard.right().onPressDo{entrenador.moverR()}
		keyboard.left().onPressDo{entrenador.moverL()}
		keyboard.up().onPressDo{entrenador.moverU()}
		keyboard.down().onPressDo{entrenador.moverD()}
	
	}	
}
	
