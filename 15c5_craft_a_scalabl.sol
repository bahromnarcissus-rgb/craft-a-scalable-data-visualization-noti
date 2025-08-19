pragma solidity ^0.8.0;

contract CraftAScalableNotifier {
    // Mapping to store visualization data
    mapping (address => VisualizationData[]) public visualizations;

    // Struct to represent visualization data
    struct VisualizationData {
        uint256 id;
        string title;
        string description;
        uint256[] dataPoints;
        uint256 lastUpdated;
    }

    // Event emitted when new visualization data is added
    event NewVisualizationData(address indexed owner, uint256 indexed id);

    // Function to add new visualization data
    function addVisualizationData(string memory _title, string memory _description, uint256[] memory _dataPoints) public {
        VisualizationData memory newData = VisualizationData(
            uint256(keccak256(abi.encodePacked(_title, _description, _dataPoints))),
            _title,
            _description,
            _dataPoints,
            block.timestamp
        );

        visualizations[msg.sender].push(newData);
        emit NewVisualizationData(msg.sender, newData.id);
    }

    // Function to update existing visualization data
    function updateVisualizationData(uint256 _id, uint256[] memory _newDataPoints) public {
        for (uint256 i = 0; i < visualizations[msg.sender].length; i++) {
            if (visualizations[msg.sender][i].id == _id) {
                visualizations[msg.sender][i].dataPoints = _newDataPoints;
                visualizations[msg.sender][i].lastUpdated = block.timestamp;
                return;
            }
        }
    }

    // Function to get visualization data by ID
    function getVisualizationData(uint256 _id) public view returns (VisualizationData memory) {
        for (uint256 i = 0; i < visualizations[msg.sender].length; i++) {
            if (visualizations[msg.sender][i].id == _id) {
                return visualizations[msg.sender][i];
            }
        }
        revert("Visualization data not found");
    }
}