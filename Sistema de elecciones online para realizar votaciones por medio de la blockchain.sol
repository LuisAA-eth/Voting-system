// SPDX-License-Identifier: MIT

pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

//------------------------------------------
//   CANDIDATO  !   EDAD      !    ID       !
//------------------------------------------
//    ROMERO    !    33       !    547866  
//    AYALA     !    35       !    475769   
//    GONZALEZ  !    31       !    957698
//    MUÑOZ     !    34       !    386590 
//    AMAYA     !    33       !    784320
//--------------------------------------------



contract Votaciones {
    
     // Direccion del propietario del contrato sistema de electoral
     address public owner;

     // Constructor para asignarle el valor al owner

     constructor() public {
         owner = msg.sender;
     }

    //Relacion del nombre del candidato con el hash de sus datos personales

    mapping(string => bytes32) ID_Candidato;

    //Ralacion entre el nombre del candidato con el numero de votos

    mapping(string => uint) cantidad_votos;

    //Lista para almacenar el nombre de los candidatos

    string[] Candidatos;  //array dinamico

    //Lista de votantes por medio del hash de su direccion 

    bytes32[] Votantes;


    // Con esta funcion cualquier persona puede postularse a las elecciones

    function Postularte(string memory _nombrePostulante , uint _edadPostulante , string memory _IdPostulante) public {
        
      //Hash de los datos del Postulante

      bytes32 hash_Postulante = keccak256(abi.encodePacked(_nombrePostulante , _edadPostulante , _IdPostulante));
      

      //Almacenar el hash de los datos del postulante ligados a su nombre

      ID_Candidato[_nombrePostulante] = hash_Postulante;

      //Almacenamos el nombre del candidato a la lista

      Candidatos.push(_nombrePostulante);

    }

     //Permite visualizar las personas que se han postulado como candidatos

     function VerCandidatos() public view returns (string[] memory){
        //Devuelve la lista de los candidatos postulados
         return Candidatos;
     }

     //Los votantes van a poder votar

     function Votar(string memory _candidato) public {
         // Calcular el hash de la direccion del votante 

         bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));

         //Verificamos si el votante ya ha votado 
         for(uint i = 0 ; i < Votantes.length ; i++){
            
            require(Votantes[i] != hash_Votante , "Ya Votaste" );
         }

         //Almacenamos el hash del votante dentro de la lista de Votantes en caso de que no halla votado

         Votantes.push(hash_Votante);

         //Añadimos un voto el candidato seleccionado
            cantidad_votos[_candidato]++;
     }
        // Vas a poder ver la cantidad de votos que tiene cada candidato
    function VerVotos(string memory _candidato) public view returns (uint) {
        return cantidad_votos[_candidato];
    }

     //Funcion auxiliar que transforma un uint a un string

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
  
   function VerResultados() public view returns (string memory){
       //Guardamos en una variable string los candidatos y su nomero de votos 
        string memory Resultados;
       //Recorremos el array de candidatos para actualizar el string de resultados
        for(uint i = 0 ; i < Candidatos.length; i++){
    //Actualizamos el string de resultados y añadimos el candidato que ocupa la posicion "i"
    // Y su numero de votos
       Resultados = string(abi.encodePacked(Resultados, "(" , Candidatos[i], "," , uint2str(VerVotos(Candidatos[i])), ")---" ));
        }
     // Devolvemos los resultados
     return Resultados;
   }

   //Proporcionar el nombre del candidato ganador
    function Ganador() public view returns(string memory){
        
        //La variable ganador contendra el nombre del candidato ganador 
        string memory ganador= Candidatos[0];
        bool flag;
        
        //Recorremos el array de candidatos para determinar el candidato con un numero de votos mayor
        for(uint i=1; i<Candidatos.length; i++){
            
            if(cantidad_votos[ganador] < cantidad_votos[Candidatos[i]]){
                ganador = Candidatos[i];
                flag=false;
            }else{
                if(cantidad_votos[ganador] == cantidad_votos[Candidatos[i]]){
                    flag=true;
                }
            }
        }
        
        if(flag==true){
            ganador = "¡Hay empate entre los candidatos!";
            
        }
        return ganador;
    }

}