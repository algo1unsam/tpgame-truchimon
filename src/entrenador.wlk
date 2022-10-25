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
	var property pokemones = []
	
	override method perfilPoke() = 'l'
}

object entrenador inherits Estados{
	var property pokemones = [new Ponita(estado= self), new Zumbat(estado = self), new Miau(estado = self)]
	var property capacidadPokedex = 10
	var property pokeballs = 10
	var property starter = null
	
//CODIGO DE IMAGEN Y MOVIMIENTO
	var img = 1
	var dir = "F"
	var property y = 0
	var property x = 2
	var property position = game.at(x,y)
	
	override method perfilPoke() = 'r'
	
	method image(){
		return dir+((img%3)+1)+".png"
	}
	
	method moverR(){
		dir = "R"
		img += 1
		x += 1
		x = x.limitBetween(0,config.width() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			//game.say(self, mensajes.choque())
			x -= 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.choque())
			x -= 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			//game.say(self, mensajes.entrada())
			interiorHospital.iniciar()
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.entrada())
			principal.iniciar()
		}
		
		if (config.encuentraCuradorEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			x -= 1
			x = x.limitBetween(0,config.width() - 1)
			pokemones.forEach{truchi => truchi.revivir()}
			game.say(self,'CURADOS!!')
			
		}
		
		
		
		
		
		
		position = game.at(x,y)
	}
	
	method moverL(){
		dir = "L"
		img += 1
		x -= 1
		x = x.limitBetween(0,config.width() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			game.say(self, mensajes.choque())
			x += 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.choque())
			x += 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			interiorHospital.iniciar()
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.entrada())
			principal.iniciar()
		}
		
		if (config.encuentraCuradorEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			pokemones.forEach{truchi => truchi.revivir()}
			game.say(self,'CURADOS!!')
			x += 1
			x = x.limitBetween(0,config.width() - 1)
		}
		
		position = game.at(x,y)
	}
	
	method moverD(){
		dir = "F"
		img += 1
		y -= 1
		y = y.limitBetween(0,config.height() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			game.say(self, mensajes.choque())
			y += 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.choque())
			y += 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			interiorHospital.iniciar()
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.entrada())
			principal.iniciar()
		}
		
		if (config.encuentraCuradorEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			pokemones.forEach{truchi => truchi.revivir()}
			game.say(self,'CURADOS!!')
			y += 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		position = game.at(x,y)
	}
	
	method moverU(){
		dir = "B"
		img += 1
		y += 1
		y = y.limitBetween(0,config.height() - 1)
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			game.say(self, mensajes.choque())
			y -= 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.choque())
			y -= 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			interiorHospital.iniciar()
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			//game.say(self, mensajes.entrada())
			principal.iniciar()
		}
		
		if (config.encuentraCuradorEn(game.at(x,y)) and config.escenarioActual().toString() == mensajes.interiorName()) {
			pokemones.forEach{truchi => truchi.revivir()}
			game.say(self,'CURADOS!!')
			y -= 1
			y = y.limitBetween(0,config.height() - 1)
		}
		
		
		position = game.at(x,y)
	}
//FIN CODIGO DE IMAGEN Y MOVIMIENTO

	method capturarPokemon(pokemon){
		if(pokeballs > 0 and pokemones.size()<capacidadPokedex){
			pokemones.add(pokemon)
		} else {
			//Msj de que no hay pokeballs	
		}
	}
	
	method batallar(){
		
	}

	method truchimonElegido(){
		const num = 0.randomUpTo(pokemones.size()-1)
		return pokemones.get(num)
	}
	
	method elegirPokemon(){
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
}





