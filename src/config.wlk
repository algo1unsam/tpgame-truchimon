import escenarios.*
import wollok.game.*

object config {
	// var property escenarioActual = intro // intro, main, jungla, hospital o batalla	
	var property starter = null
	const property width = 24
	const property height = 14
	
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
		self.cambiarEscenario(principal)
		principal.iniciar()
	}
	
	method colisionaEn(proximaPosicion) {
		return escenarioActual.colisionables()
		.flatMap{
			colisionable => colisionable.bloques()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	
	method entraAlEscenarioEn(proximaPosicion) {
		return escenarioActual.colisionables()
		.map{
			colisionable => colisionable.entrada()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	
	method encuentraCuradorEn(proximaPosicion){
		return escenarioActual.curadores()
		.flatMap{
			colisionable => colisionable.bloques()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	
	
	
	
	method cambiarEscenario(escenario) {
		escenarioActual = escenario
	}
}


object mensajes {
	const property choque = ""
	const property entrada = "Entrandoooooo"
	const property junglaName = "Jungla"
	const property hospitalName = "Hospital"
	const property coliseoName = "Coliseo"
	const property principalName = "principal"
	const property introName = "Intro"
	const property interiorName = 'interiorHospital'
}