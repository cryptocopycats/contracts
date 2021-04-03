
interface ForeignToken {

    function balanceOf(address) external view returns (uint);

    function transfer(address, uint) external returns (bool);
}

