import escenarios.*
import truchimones.*
import wollok.game.*

object config {
	// var property escenarioActual = intro // intro, main, jungla, hospital o batalla	
	var property starter = null
	const property width = 24
	const property height = 14
	const property colisionables = [jungla, hospital, coliseo, casarandom, bosque, lago]
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
			punto => punto == proximaPosicion
		}
	}
	
	method entraAlEscenarioEn(proximaPosicion) {
		return colisionables
		.map{
			colisionable => colisionable.entrada()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	
	method cambiarEscenario(escenario) {
		escenarioActual = escenario
	}
}

object truchimones {
	const property listado = [
		fuego1, fuego2, planta1, planta2, agua1, agua2,
		tierra1, tierra2, metal1, metal2, hielo1,
		hielo2, viento1, viento2, normal1, normal2
	]
	
	method obtenerTruchimonesRandom(cantidad) {
		
	}
}


object mensajes {
	const property choque = ""
	const property entrada = "Entrandoooooo"
	const property junglaName = "Jungla"
	const property hospitalName = "Hospital"
	const property coliseoName = "Coliseo"
	const property principalName = "Principal"
	const property introName = "Intro"
}