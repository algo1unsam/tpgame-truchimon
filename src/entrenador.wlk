import wollok.game.*
import config.*
import escenarios.*
import truchimones.*

class Estados{
	method perfilPoke()
}

object salvaje inherits Estados{
	override method perfilPoke() = 'f'
}

object enemigo inherits Estados{	
	override method perfilPoke() = 'l'
}


object amigo inherits Estados{ //Reemplazar por estado entrenador en el merge!!!!
	override method perfilPoke() = 'r'
}


object entrenador{// ver de que no genere siempre una instanciacion nueva, para poder almacenar experiencia
	var property truchimones = [ new Ponita(estado= amigo), new Zumbat(estado = amigo), new Miau(estado = amigo)]
	var property capacidadPokedex = 10
	var property pokeballs = 10
	var property starter = null
	var property truchimonEnUso = truchimones.get(0)
	
//CODIGO DE IMAGEN Y MOVIMIENTO
	var img = 1
	var dir = "F"
	var y = 0
	var x = 2
	var property position = game.at(x,y)
	
	method image(){
		return dir+((img%3)+1)+".png"
	}
	
	method moverR(){
		dir = "R"
		img += 1
		x += 1
		x = x.limitBetween(0,config.width() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			//game.say(self, mensajes.choque())
			x -= 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			//game.say(self, mensajes.entrada())
			junglaModo.iniciar()
		}
		position = game.at(x,y)
	}
	
	method moverL(){
		dir = "L"
		img += 1
		x -= 1
		x = x.limitBetween(0,config.width() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.choque())
			x += 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			junglaModo.iniciar()
		}
		position = game.at(x,y)
	}
	
	method moverD(){
		dir = "F"
		img += 1
		y -= 1
		y = y.limitBetween(0,config.height() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.choque())
			y += 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			junglaModo.iniciar()
		}
		position = game.at(x,y)
	}
	
	method moverU(){
		dir = "B"
		img += 1
		y += 1
		y = y.limitBetween(0,config.height() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.choque())
			y -= 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			junglaModo.iniciar()
		}
		position = game.at(x,y)
	}
//FIN CODIGO DE IMAGEN Y MOVIMIENTO

	method capturarPokemon(pokemon){
		if(pokeballs > 0 and truchimones.size()<capacidadPokedex){
			truchimones.add(pokemon)
		} else {
			//Msj de que no hay pokeballs	
		}
	}
	
	method batallar(){
		
	}
	
	method puedeElegir(indice){
		return not truchimones.get(indice).murio()
	}
	

	method truchimonElegido(){
		const num = 0.randomUpTo(truchimones.size()-1)
		return truchimones.get(num)
	}
	
	method elegirTruchimon(indice){
		truchimonEnUso = truchimones.get(indice)
		
		//Hacer visual de los pokemones en la pokedex
		//keyboard.num0().onPressDo({return pokemones.index(0)})
		//keyboard.num1().onPressDo({return pokemones.index(1)})
		//keyboard.num2().onPressDo({return pokemones.index(2)})
		//keyboard.num3().onPressDo({return pokemones.index(3)})
		//keyboard.num4().onPressDo({return pokemones.index(4)})
		//keyboard.num5().onPressDo({return pokemones.index(5)})
		//keyboard.num6().onPressDo({return pokemones.index(6)})
		//keyboard.num7().onPressDo({return pokemones.index(7)})
		//keyboard.num8().onPressDo({return pokemones.index(8)})
		//keyboard.num9().onPressDo({return pokemones.index(9)})
	}
	
	method tieneEsteTruchi(indice){
		return truchimones.size()>indice
	}
	
	method puedeSeguir(){
		return truchimones.any({t => not t.murio()})
	}
	
}

class EntrenadorEnemigo{
	const property truchimones = []
	var property truchimonEnUso = null
	var property indiceTruchi = 0
	
	method initialize(){
		truchimonEnUso = truchimones.get(0)
	}
	
	method truchimonElegido(){
		const num = 0.randomUpTo(truchimones.size()-1)
		return truchimones.get(num)
	}
	
	method puedeElegir(indice){
		return not truchimones.get(indice).murio()
	}
	
	method elegirTruchimon(){
		truchimonEnUso = truchimones.get(indiceTruchi)
	}
	
	method puedeSeguir(){
		return truchimones.any({t => not t.murio()})
	}
	
	method aumentarIndice(){
		indiceTruchi+=1
	}
	
}

object malazo inherits EntrenadorEnemigo{//todos nivel 1
	override method initialize(){
		truchimones.addAll([new Ponita(estado=enemigo), new Glacion(estado = enemigo), new Jeodud(estado=enemigo)])
		super()
	}
}

object capo inherits EntrenadorEnemigo{//todos nivel 3 VER como subir de nivel
	override method initialize(){
		truchimones.addAll([new Jorsi(estado=enemigo), new Magnemait(estado = enemigo), new Iivii(estado=enemigo)])
		super()
	}
}

object recapo inherits EntrenadorEnemigo{//todos nivel 5
	override method initialize(){
		truchimones.addAll([new Jorsi(estado=enemigo), new Magnemait(estado = enemigo), new Iivii(estado=enemigo)])
		super()
	}
}









