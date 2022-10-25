import wollok.game.*
import config.*
import escenarios.*
import truchimones.*
import batalla.*

class Estados{
	method perfilPoke()
}

object salvaje inherits Estados{
	override method perfilPoke() = 'f'
}

object enemigo inherits Estados{
	override method perfilPoke() = 'l'
}

object amigo inherits Estados{
	override method perfilPoke() = 'r'
}

class Entrenador{
	var property truchimones = []
	var property truchimonEnUso = null
	var property capacidadTruchidex
	var truchiBalls
	
	method truchimonElegido() = truchimones.get(0.randomUpTo(truchimones.size()-1))
	method puedeAtacar() = truchimones.any({ truchi => truchi.vivo() })
	method truchimonesListos() = truchimones.filter({ truchi => truchi.vivo() })
	method truchidexLleno() = ((capacidadTruchidex - truchimones.size()) == 0)
	method hayTruchiBalls() = (truchiBalls != 0)	
}

object player inherits Entrenador(truchiBalls = 1, capacidadTruchidex = 3){
	var property image = 'b1.png'
		
//CODIGO DE IMAGEN Y MOVIMIENTO
	var img = 1
	var counter = 0
	var y = 0
	var x = 2
	var property position = game.at(x,y)
	
	method incrementarImg() { 
		img += 1
		return ((img%3)+1)
	} 
		
	method doMovement(){
		game.onCollideDo(self,{ obj => if (!obj.equals(fondo)) self.do(obj) })		
	}
	
	method do(obj){
		obj.visible(true)
		if(self.truchimones().any({ truchi => truchi.vivo()})){
			game.say(self, 'Te encontre..')
			game.schedule(2000, { batalla.graficar(obj)} )
		} else {
			game.say(self, 'Hay que ir al hospital!!')
		}
	}
	
	method mover(dir){
		
		self.image(dir + self.incrementarImg() + '.png')
		
		if(dir == 'B') 	y += 1
		if(dir == 'F') 	y -= 1
		if(dir == 'R') 	x += 1
		if(dir == 'L') 	x -= 1		
		
		if (dir == 'B' or dir == 'F') {
			y = y.limitBetween(0, config.height() - 1)
		} else {
			x = x.limitBetween(0,config.width() - 1)
		}
		
		if (config.colisionaEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			counter += 1
			if(counter%7 == 0 or counter == 1)	game.say(self, mensajes.choque())
			if(dir == 'B') 	y -= 1
			if(dir == 'F') 	y += 1
			if(dir == 'R') 	x -= 1
			if(dir == 'L') 	x += 1
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y)) and config.escenarioActual() == mensajes.principalName()) {
			game.say(self, mensajes.entrada())
			game.schedule(1000, { junglaModo.iniciar() })
		}
		
		self.doMovement()
		position = game.at(x,y)
	}	
	// FIN CODIGO DE IMAGEN Y MOVIMIENTO
	
	method capturarTruchi(truchi) {		
		if( self.hayTruchiBalls() && !self.truchidexLleno() ){
			truchimones.add(truchi)
		}
	}
	
	method batallar(){
		
	}

	method puedeElegir(indice){
		return truchimones.get(indice).vivo()
	}
	
	method elegirTruchimon(indice){
		truchimonEnUso = self.truchimonElegido()//truchimones.get(indice)
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