import wollok.game.*
import truchimones.*
import entrenador.*
import escenarios.*

object batalla{
	var turno = 0
	
	var property peleaEntrenador = false
	var property indiceEntrenador = null
	
	
	var property truchi_amigo = null
	var property truchi_enemigo = null
	
	
	var property captura = false
	
	
	const stats_uno = new CuadroEstado()
	const stats_dos = new CuadroEstado()
	
	const heart_uno = new ObjetoHeart()
	const heart_dos = new ObjetoHeart()
	
	const vidaAmigo = new VidaTruchi()
	const vidaEnemigo = new VidaTruchi()
	
	const nombreAmigo = new NombreTruchi()
	const nombreEnemigo = new NombreTruchi()
	
	
	method graficar(enemigo_){
		game.clear()
				
		truchi_enemigo = enemigo_
		truchi_amigo = player.truchimonElegido()
		
		self.settings()
		self.pantalla()
		self.controles()
	}
	
	method esAmigo() = truchi_amigo
	method esEnemigo() = truchi_enemigo	
		
	method settings() {
		//Set amigo
		truchi_amigo.visible(true)
		truchi_amigo.position(game.at(6,4))
		
		//Set enemigo
		truchi_enemigo.visible(true)
		truchi_enemigo.estado(enemigo)
		truchi_enemigo.position(game.at(13,7))
		
		//Set menues
		fondoBatalla.position(game.origin())
		menuOpciones.position(game.at(5,0))
		stats_uno.position(game.at(0,12))
		stats_dos.position(game.at(18,12))
		
		//Set textos menues
		txtMenu.generar(truchi_amigo)
		txtMenu.position(game.at(12,2))
		
		//Set corazones
		heart_uno.position(game.at(5,13))
		heart_dos.position(game.at(23,13))
		
		//Set nro de vida
		vidaAmigo.position(game.at(4,13))
		vidaAmigo.generar(truchi_amigo)
		vidaEnemigo.position(game.at(22,13))
		vidaEnemigo.generar(truchi_enemigo)
		
		//Set nombres Truchis
		nombreAmigo.position(game.at(1,13))
		nombreAmigo.generar(truchi_amigo)
		nombreEnemigo.position(game.at(19,13))
		nombreEnemigo.generar(truchi_enemigo)
			
	}
	
	method controles(){
		(1..(truchi_amigo.movimientos().size())).forEach({ index => keyboard.num(index).onPressDo{self.turnoAmigo(index-1)}})
		(5..(player.truchimonesListos().size()+4)).forEach({ index => keyboard.num(index).onPressDo{self.cambiarTruchiAmigo(index-5)}})
		keyboard.num(9).onPressDo{self.elijoCapturar()}
		
	}
	
	method pantalla() {
		[	fondoBatalla, truchi_amigo, truchi_enemigo, stats_uno, stats_dos, 
		 	menuOpciones, heart_uno, heart_dos, txtMenu, vidaAmigo, vidaEnemigo,
		 	nombreAmigo, nombreEnemigo
		].forEach({ e => game.addVisual(e)})		
	}
	
	method iniciar(){
		if (not player.puedeSeguir()) {
			self.finBatalla(truchi_enemigo)
		} else if (!truchi_enemigo.vivo()) {
			self.finBatalla(truchi_amigo)
		} else if (!(turno%2==0)){			
			self.turnoEnemigo()						
		}else{
			self.controles()
		}
		
	}
	
	method limpiarElementos(){
		game.removeVisual(nombreAmigo)
		game.removeVisual(nombreEnemigo)
		game.removeVisual(vidaAmigo)
		game.removeVisual(vidaEnemigo)
		game.removeVisual(truchi_amigo)
		game.removeVisual(truchi_enemigo)
		game.removeVisual(txtMenu)
	}
	method generarElementos(){
		
		nombreAmigo.generar(truchi_amigo)
		nombreEnemigo.generar(truchi_enemigo)
		vidaAmigo.generar(truchi_amigo)
		vidaEnemigo.generar(truchi_enemigo)
		txtMenu.generar(truchi_amigo)
	}
	method agregarElementos(){
		game.addVisual(truchi_amigo)
		game.addVisual(truchi_enemigo)
		game.addVisual(txtMenu)
		game.addVisual(nombreAmigo)
		game.addVisual(nombreEnemigo)
		game.addVisual(vidaAmigo)
		game.addVisual(vidaEnemigo)
	}
	
	method regenerarTodo(){
		self.limpiarElementos()
		self.generarElementos()
		self.agregarElementos()
		//self.controles()
	}
	
	
	method turnoAmigo(index){
		if(truchi_amigo.vivo()){
			var mov = null
					
			mov = truchi_amigo.movimientos().get(index)
			truchi_amigo.atacar(truchi_enemigo,mov)
			self.regenerarTodo()
			//game.say(truchi_amigo,'Te ataco con '+mov.nombre())
			
			turno += 1
			self.iniciar()
		}
		else{
			game.say(truchi_amigo,'Cambiame!!!')
		}
		
		
		
		
			
	}
	
	method elijoCapturar(){
		captura= !captura
		game.removeVisual(txtMenu)
		txtMenu.generar(truchi_amigo)
		game.addVisual(txtMenu)
		
	}
	
	method turnoEnemigo(){

		var mov = truchi_enemigo.movimientos().anyOne()
		truchi_enemigo.atacar(truchi_amigo,mov)
		self.regenerarTodo()
		//game.say(truchi_enemigo,'Te ataco con '+mov.nombre())
		turno += 1
		self.iniciar()
		
		
	}
	
	method finBatalla(ganador){
		
		if(ganador.equals(truchi_amigo)){
			ganador.ganarXP()
			ganador.subeDeNivel()
			if(captura) player.capturarTruchi(truchi_enemigo)
			if(peleaEntrenador){
				addTrainer.lista().get(indiceEntrenador).eliminarElPrimero()
				peleaEntrenador = false
			}
			
			
			
		}		
		
		game.schedule(3000,{ principal.iniciar() })	
		
	}
	
	method cambiarTruchiAmigo(indice){
		self.limpiarElementos()
		
		truchi_amigo = player.truchimonesListos().get(indice)
		truchi_amigo.position(game.at(6,4))
		self.generarElementos()
		self.agregarElementos()
		
		//self.controles()
	}
			
}





// Objetos de la pantalla
class ObjetosBatalla{
	var property position = null
}

class ObjetoVacio{
	var property position = null
	method image() = 'vacio.png'	
}

class ObjetoHeart{
	var property position = null
	method image() = 'heart.png'
}

object fondoBatalla inherits ObjetosBatalla{
	method image() = 'battle.png'
}

object menuOpciones inherits ObjetosBatalla{
	method image() = 'cuadro.png'
}

class CuadroEstado inherits ObjetosBatalla{
	method image() = 'stats.png'
}

// Necesario para los textos

class Texto inherits ObjetoVacio{
	var property txt = null
	method text() = txt
	
	method initialize(){ txt = '\n' }
}
	
class VidaTruchi inherits Texto{
	method generar(truchi){
		txt = '\n'
		txt += truchi.salud().toString() + '/' + truchi.saludMaxima().toString()
	}		
}

class NombreTruchi inherits Texto{
	method generar(truchi){
		txt = '\n'
		txt += truchi.nombre()
	}
}

object txtMenu inherits Texto{	
	method generar(truchi) {
		var lista = truchi.movimientos()
		const tam = lista.size()
		txt = '\n'
		txt += '\n'
		(0..tam-1).forEach({ x => txt += (x+1).toString() + '- ' + lista.get(x).nombre() + '    '})
		txt = txt + '\n\n'
		lista = player.truchimonesListos()
		if(!lista.isEmpty())(5..5+lista.size()-1).forEach({ x => txt += (x).toString() + '- ' + lista.get(x-5).nombre() + '    '})
		txt += '\n9 - Captura : ' + batalla.captura().toString()
	}
}

class Globo{
	var property position = null
	var property text = null
	method image() = 'globo.png'
}

