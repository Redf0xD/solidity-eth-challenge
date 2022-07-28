// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PokemonFactory {
    enum pokemonType{
      Bug,
      Dark,
      Dragon,
      Electric,
      Fairy,
      Fighting,
      Fire,
      Flying,
      Ghost,
      Grass,
      Ground,
      Ice,
      Normal,
      Poison,
      Psychic,
      Rock,
      Steel,
      Water
    }

    struct Pokemon {
      uint id;
      string name;
      Ability[] abilities;
      pokemonType[] types;
      pokemonType[] weakness;
    }

    struct Ability{
      string name;
      string description;
    }

    Pokemon[] private pokemons;
    Ability[] private abilities;

    mapping (uint => address) public pokemonToOwner;
    mapping (address => uint) ownerPokemonCount;
    mapping(uint8 => uint) globalId;

    event eventNewPokemon(
      uint id,
      string name
    );

    event eventNewPokemonAbility(
      string name,
      string description
    );

    modifier checkPokemonData(string memory _name, uint _id){
      require(_id > 0, "Debe ser mayor a 0");
      require(bytes(_name).length > 2, "El nombre debe tener al menos dos letras");
      _;
    }

    modifier checkPokemonAbilityData(string memory name, string memory description, uint256 id){
      require(id > 0, "El id debe ser mayor a 0");
      require(bytes(name).length > 2, "El nombre debe tener al menos dos letras");
      require(bytes(description).length > 10, "Debe tener al menos 10 letras");
      _;
    }

    modifier checkPokemonExist(uint8 id) {
      require(globalId[id] > 0, "El pokemon que buscas, no existe, verifique el id");
      _;
    }

    modifier isPokemonValidType(pokemonType Type){
      require(Type < pokemonType.Water, "El tipo de pokemon no existe");
      _;
    }

    function createPokemon (string memory _name, uint8 _id) public checkPokemonData(_name, _id) {
      pokemons.push();
      uint pokemonId = pokemons.length - 1;
      pokemons[pokemonId].id = _id;
      pokemons[pokemonId].name = _name;
      pokemonToOwner[_id] = msg.sender;
      ownerPokemonCount[msg.sender]++;
      globalId[_id] = pokemonId + 1;
      emit eventNewPokemon(_id, _name);
    }

    function getAllPokemons() public view returns (Pokemon[] memory) {
      return pokemons;
    }

    function addPokemonAbility(string memory name, string memory description, uint8 id) public checkPokemonAbilityData(name, description, id) checkPokemonExist(id){
      uint idx = globalId[id];
      pokemons[idx - 1].abilities.push(Ability(name, description));
      emit eventNewPokemonAbility(name, description);
    }

    function addPokemonType(pokemonType Type, uint8 _id) public checkPokemonExist(_id) isPokemonValidType(Type){
      uint pokemonId = globalId[_id];
      pokemons[pokemonId - 1].types.push(Type);
    }

    function addPokemonWeaknesses(pokemonType weaknessesType, uint8 _id) public checkPokemonExist(_id) isPokemonValidType(weaknessesType){
      uint pokemonId = globalId[_id];
      pokemons[pokemonId - 1].weakness.push(weaknessesType);
    }

    function getResult() public pure returns(uint product, uint sum){
      uint a = 1;
      uint b = 2;
      product = a * b;
      sum = a + b;
   }

}
