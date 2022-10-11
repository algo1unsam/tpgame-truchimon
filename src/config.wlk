import escenarios.*
import wollok.game.*

object config {
	// var property escenarioActual = intro // intro, main, jungla, hospital o batalla	
	var property starter = null
	const property width = 24
	const property height = 12
	const property colisionables = [jungla, hospital, coliseo]
	var property escenarioActual = mensajes.introName()
	
	method run() {
		game.clear()
		game.width(width)
		game.height(height)
		game.cellSize(50)
		game.title("Truchimón! 👾")
		// game.ground("pasto.png")
	}
	
	method agregarStarter(truchimon) {
		starter = truchimon
		self.cambiarEscenario(mensajes.principalName())
		principal.iniciar()
	}
	
	method colisionaEn(proximaPosicion) {
		return colisionables
		.flatMap{
			colisionable => colisionable.bloques()
		}.any{
			punto => game.at(punto.get(0), punto.get(1)) == proximaPosicion
		}
	}
	
	method entraAlEscenarioEn(proximaPosicion) {
		return colisionables
		.flatMap{
			colisionable => colisionable.entrada()
		}.any{
			punto => game.at(punto.get(0), punto.get(1)) == proximaPosicion
		}
	}
	
	method cambiarEscenario(escenario) {
		escenarioActual = escenario
	}
}


object mensajes {
	const property choque = "No es por aca maestro"
	const property entrada = "Entrandoooooo"
	const property junglaName = "Jungla"
	const property hospitalName = "Hospital"
	const property coliseoName = "Coliseo"
	const property principalName = "Principal"
	const property introName = "Intro"
}