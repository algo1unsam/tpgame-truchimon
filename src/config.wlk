import escenarios.*
import wollok.game.*
import entrenador.*

object config {
	// var property escenarioActual = intro // intro, main, jungla, hospital o batalla	
	const property width = 24
	const property height = 14
	
	
	method run() {
		game.clear()
		game.width(width)
		game.height(height)
		game.cellSize(50)
		game.title("Truchimón! 👾")
	}
	
	method agregarStarter(truchimon) {
		player.truchimones(truchimon)
		principal.iniciar()
	}
	
	method colisionaEn(proximaPosicion,escenario) {
		return escenario.colisionables()
		.flatMap{
			colisionable => colisionable.bloques()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	
	method entraAlEscenarioEn(proximaPosicion,escenario) {
		return escenario.colisionables()
		.map{
			colisionable => colisionable.entrada()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	method encuentraCuradorEn(proximaPosicion,escenario){
		return escenario.curadores()
		.flatMap{
			colisionable => colisionable.bloques()
		}.any{
			punto => punto == proximaPosicion
		}
	}
	
}


object mensajes {
	const property choque = "por aca no!!"
	const property entrada = "Entrandoooooo"
	}