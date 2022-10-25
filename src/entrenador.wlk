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
    method puedeAtacar() = truchimones.any({ truchi => truchi.vivo() })
	method truchimonesListos() = truchimones.filter({ truchi => truchi.vivo() })
    method truchimonElegido() = truchimones.get(0)
    method puedeSeguir()= return not self.truchimonesListos().isEmpty()
}

class EntrenadorAmigo inherits Entrenador{
	
	
	var property capacidadTruchidex
	var truchiBalls
	
	override method truchimonElegido() = self.truchimonesListos().get(0.randomUpTo(self.truchimonesListos().size()-1))
	method truchidexLleno() = ((capacidadTruchidex - truchimones.size()) == 0)
	method hayTruchiBalls() = (truchiBalls != 0)	
}

object player inherits EntrenadorAmigo(truchiBalls = 100, capacidadTruchidex = 3){
	var property image = 'b1.png'
		
//CODIGO DE IMAGEN Y MOVIMIENTO
	var img = 1
	var counter = 0
	var y = 0
	var x = 2
	var property position = game.at(x,y)
    var property dondeEstoy = principal
	
	method incrementarImg() { 
		img += 1
		return ((img%3)+1)
	} 
		
	method doMovement(){
		game.onCollideDo(self,{ obj =>
			if(obj.esTruchimon()){
				if (obj.esInvisibleEnJungla()) self.do(obj)
				else{
					const truchi = obj.truchimones().first()
					const indiceEntre = obj.indiceEnLista()
					batalla.indiceEntrenador(indiceEntre) 
					batalla.peleaEntrenador(true)
					batalla.graficar(truchi)
				}
			}
			
		})		
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
		
		if (config.colisionaEn(game.at(x,y),dondeEstoy)) {//and config.escenarioActual() == mensajes.principalName()) {
			counter += 1
			if(counter%7 == 0 or counter == 1)	game.say(self, mensajes.choque())
			if(dir == 'B') 	y -= 1
			if(dir == 'F') 	y += 1
			if(dir == 'R') 	x -= 1
			if(dir == 'L') 	x += 1
		}
		
		if (config.entraAlEscenarioEn(game.at(x,y),dondeEstoy) ){//and config.escenarioActual() == mensajes.principalName()) {
			//game.say(self, mensajes.entrada())
            if(dondeEstoy.equals(principal)){
                dondeEstoy = interiorHospital
                self.iniciarPosicion(7,2)
                //game.schedule(10,{self.iniciarPosicion(18,10)})
                
                
               interiorHospital.iniciar()
            }
            else if(dondeEstoy.equals(interiorHospital)){
                dondeEstoy = principal
                self.iniciarPosicion(18,10)
                
                //game.schedule(10,{self.iniciarPosicion(7,2)})
                
                principal.iniciar()
            }
		}
        if (config.encuentraCuradorEn(game.at(x,y),dondeEstoy) ) {
        	counter += 1
			if(counter%7 == 0 or counter == 1)	game.say(self, mensajes.choque())
			if(dir == 'B') 	y -= 1
			if(dir == 'F') 	y += 1
			if(dir == 'R') 	x -= 1
			if(dir == 'L') 	x += 1
			truchimones.forEach{truchi => truchi.revivir()}
			game.say(self,'CURADOS!!')
		}
		
		
		self.doMovement()
		position = game.at(x,y)
	}	
	// FIN CODIGO DE IMAGEN Y MOVIMIENTO
	
	method capturarTruchi(truchi) {		
		if( self.hayTruchiBalls() && !self.truchidexLleno() ){
			truchi.estado(amigo)
			truchimones.add(truchi)
		}
	}
	
	method batallar(){
		
	}

	method puedeElegir(indice){
		return truchimones.get(indice).vivo()
	}
	
	method elegirTruchimon(indice){
		truchimonEnUso = self.truchimonesListos().get(indice)//truchimones.get(indice)
		
	}

	method tieneEsteTruchi(indice){
		return truchimones.size()>indice
	}
	
	method iniciarPosicion(_x,_y){
		x=_x
		y=_y
	}	
}
class EntrenadorEnemigo inherits Entrenador{

	var property indiceTruchi = 0
	var property position 
	var property leGane = false
	
	method esTruchimon()=true
	method esInvisibleEnJungla()=false
	
	method initialize(){
		truchimonEnUso = truchimones.get(0)
	}
	
	method resetear(){
		indiceTruchi=0
		leGane = false
		truchimones.forEach({t=>t.revivir()})
	}
	
	
	
	method puedeElegir(indice){
		return not truchimones.get(indice).murio()
	}
	
	method elegirTruchimon(){
		truchimonEnUso = truchimones.get(indiceTruchi)
	}
	
	
	
	method aumentarIndice(){
		indiceTruchi+=1
	}
	
	method eliminarElPrimero(){
		truchimones.remove(truchimones.first())
	}
	
	method tieneTruchimones(){
		return not truchimones.isEmpty()
	}
	
	method indiceEnLista(){
		return 0
	}
	
		
}

object malazo inherits EntrenadorEnemigo(position = freeMap.randomPos() ){//todos nivel 1
	override method initialize(){
		truchimones.addAll([new Ponita(estado=enemigo), new Glacion(estado = enemigo), new Jeodud(estado=enemigo)])
		super()
	}
	method image() = 'e1.png'
	
}

object capa inherits EntrenadorEnemigo(position = freeMap.randomPos() ){//todos nivel 3 VER como subir de nivel
	override method initialize(){
		truchimones.addAll([new Jorsi(estado=enemigo), new Magnemait(estado = enemigo), new Iivii(estado=enemigo)])
		super()
	}
	method image() = 'e2.png'
	override method indiceEnLista()=1
}

object recapa inherits EntrenadorEnemigo(position = freeMap.randomPos() ){//todos nivel 5
	override method initialize(){
		truchimones.addAll([new Jorsi(estado=enemigo), new Magnemait(estado = enemigo), new Iivii(estado=enemigo)])
		super()
	}
	
	method image()='e3.png'
	override method indiceEnLista()=2
}