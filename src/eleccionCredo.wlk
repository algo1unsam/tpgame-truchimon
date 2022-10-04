import wollok.game.*
import entrenador.*
import juego.*

object pantallaInicio {
	method iniciar(){
		game.width(13)
		game.height(10)
		game.title("Truchimon")
		game.addVisualIn(backgnd,game.at(0,3))
		game.addVisualIn(text,game.origin())
		
		keyboard.num1().onPressDo{juego.iniciar(planta) }
		keyboard.num2().onPressDo{juego.iniciar(agua)}
		keyboard.num3().onPressDo{juego.iniciar(fuego)}
		
		game.start()
	}
}

object backgnd{
	method image(){
		return "bkgnStarter.jpeg"
	}
} 

object text{
	method image(){
		return "starterOptions.png"
	}
} 