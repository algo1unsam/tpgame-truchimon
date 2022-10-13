import wollok.game.*
import truchimones.*
import entrenador.*


object batalla {
	var property estatus = 5
	var turno = 0
	var indice = 0
	var mov = null
	var property tr1= entrenador.truchimonElegido() //Cuando pase la pelea, vamos a setarlos en base a lo que decidamos
	var property tr2=bulbasaur
	method iniciar(){
		
		keyboard.enter().onPressDo({self.pelea(verguigneo,bulbasaur)})
		keyboard.num1().onPressDo{self.nuestroTurno(tr1,tr2,0)}
		keyboard.num2().onPressDo{self.nuestroTurno(tr1,tr2,1)}
		keyboard.num3().onPressDo{self.nuestroTurno(tr1,tr2,2)}
		keyboard.num4().onPressDo{self.nuestroTurno(tr1,tr2,3)}
		game.start()
		
	}
	
	method pelea(t1,t2){
		
		if(turno%2==0){//Nuestro turno
			//Mostrar los ataques
			console.println('Nuestro turno')
			
		}
		else{
			//mov es random para el otro
			self.turnoPc(tr2,tr1)
		}
		
		
	}
	method finBatalla(ganador){
		console.println('Fin Batalla, gano '+ganador.nombre()+'!!!')
		//jungla.iniciar() o coliseo, volver a donde estemos.
	}
	
	method nuestroTurno(t1,t2,indecs){
		console.println('Nuestro turno')
		mov= t1.movimientos().get(indecs)
		turno+=1
		console.println('Elegimos '+mov.nombre())
		
		console.println('La vida de '+t2.nombre()+' es de '+t2.salud().toString())
		t1.atacar(t2,mov)
		console.println('La vida de '+t2.nombre()+' es de '+t2.salud().toString())
		
		if(not t2.murio()){
			self.pelea(t2,t1)
		}
		else{self.finBatalla(t1)}
		
	}
	
	method turnoPc(t2,t1){
		mov=tacle
		turno+=1
		
		console.println('Turno de '+t2.nombre())
		
		t2.atacar(t1,mov)
		
		if(not t1.murio()){
			self.pelea(t1,t2)
		}
		else{self.finBatalla(t2)}
	}
	
	
	
	
	
	
}
