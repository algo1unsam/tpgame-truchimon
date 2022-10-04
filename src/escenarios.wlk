import wollok.game.*

class Escenario {
	
}


object hospital inherits Escenario {
	method position() = game.at(10, 0)

	method image() = "hospital.png"
}

object jungla inherits Escenario {
	method position() = game.at(0, 10)

	method image() = "jungla.png"
}

object coliseo inherits Escenario {
	method position() = game.at(20, 10)

	method image() = "jungla.png" // TODO: cambiar visual
}