blocks = 
	{ --Block Name, Block Name, 				      					Vox/XML Path, 							      		Axis Rotation, 		  		Block Properties,			Block Size,					Offset,						specialFeatures(shape), alwaysProp, blockType (block, door, slab, fence, stairs, trapdoor, redstone, fencegate, item), ExtraXML}
		["Grass"] = {"Grass", 			      							"MOD/vox/blocks/grass.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Dirt"] = {"Dirt", 			    	  						"MOD/vox/blocks/dirt.vox", 			     			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Stone"] = {"Stone", 	  		      							"MOD/vox/blocks/stone.vox", 			     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cobblestone"] = {"Cobblestone",								"MOD/vox/blocks/cobblestone.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cobblestone Slab"] = {"Cobblestone Slab",						"MOD/vox/blocks/cobblestoneslab.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		["Cobblestone Stairs"] = {"Cobblestone Stairs",      			"MOD/vox/blocks/cobblestonestairs.vox",     		{x = 0, y = 1,  z = 0},   	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		["Mossy Cobblestone"] = {"Mossy Cobblestone",       			"MOD/vox/blocks/mossycobble.vox", 		  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Oak Log"] = {"Oak Log", 		  	    						"MOD/vox/blocks/oaklog.vox", 		          		{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Oak Leaves"] = {"Oak Leaves",   		      					"MOD/vox/blocks/oakleaves.vox", 	          		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Oak Planks"] = {"Oak Planks", 	          					"MOD/vox/blocks/oakplanks.vox", 	          		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Oak Plank Slab"] = {"Oak Plank Slab",        					"MOD/vox/blocks/oakplankslab.vox",   		  		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		["Oak Plank Stairs"] = {"Oak Plank Stairs",      				"MOD/vox/blocks/oakplankstairs.vox",     			{x = 0, y = 1,  z = 0},   	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		["TNT"] = {"TNT", 				     							"MOD/vox/blocks/tnt.vox", 				  			{x = 0, y = 0,  z = 0}, 	"tags='explosive=2'", 		{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true, 		7, nil}, 
		["Crafting Table"] = {"Crafting Table", 	     				"MOD/vox/blocks/craftingtable.vox", 	     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		["Smithing Table"] = {"Smithing Table", 	      				"MOD/vox/blocks/smithingtable.vox", 	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Furnace"] = {"Furnace", 			      						"MOD/vox/blocks/furnace.vox", 			  			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		["Torch"] = {"Torch", 			      							"MOD/vox/blocks/torch.vox", 			      		{x = 0, y = 0,  z = 0}, 	"tags='nocull'",			{x = 16, y = 16, z = 16},	{x = -3, y = -3, z = -3},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='1 0.85 0.31' scale='5.00' unshadowed='0.1'/>"},
		["Bricks"] = {"Bricks", 			      						"MOD/vox/blocks/bricks.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		["Sand"] = {"Sand", 				      						"MOD/vox/blocks/sand.vox", 			      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true, 		1, nil},
		["Soul Sand"] = {"Soul Sand", 				      				"MOD/vox/blocks/soulsand.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Sandstone"] = {"Sandstone", 		     						"MOD/vox/blocks/sandstone.vox", 		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cut Sandstone"] = {"Cut Sandstone", 	      					"MOD/vox/blocks/cutsandstone.vox", 	      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Chiseled Sandstone"] = {"Chiseled Sandstone",					"MOD/vox/blocks/chiseledsandstone.vox",     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Smooth Sandstone"] = {"Smooth Sandstone", 	      			"MOD/vox/blocks/smoothsandstone.vox",       		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Smooth Stone"] = {"Smooth Stone", 		      				"MOD/vox/blocks/smoothstone.vox", 		  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Smooth Stone Slab"] = {"Smooth Stone Slab",       			"MOD/vox/blocks/smoothstoneslab.vox", 	  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		["Stone Bricks"] = {"Stone Bricks", 		      				"MOD/vox/blocks/stonebricks.vox", 		  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Stone Brick Stairs"] = {"Stone Brick Stairs",      			"MOD/vox/blocks/stonebrickstairs.vox",      		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		["Stone Brick Slab"] = {"Stone Brick Slab",       	 			"MOD/vox/blocks/stonebrickslab.vox",        		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		["Bedrock"] = {"Bedrock", 			      						"MOD/vox/blocks/bedrock.vox", 			  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Basalt"] = {"Basalt", 			      						"MOD/vox/blocks/basalt.vox", 			      		{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Smooth Basalt"] = {"Smooth Basalt", 							"MOD/vox/blocks/smoothbasalt.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		["Glass"] = {"Glass", 			     							"MOD/vox/blocks/glass.vox", 			      		{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Loom"] = {"Loom", 				      						"MOD/vox/blocks/loom.vox", 			      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cartography Table"] = {"Cartography Table",       			"MOD/vox/blocks/cartographytable.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cauldron"] = {"Cauldron",  		      						"MOD/vox/blocks/cauldron.vox", 		      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Hay Bale"] = {"Hay Bale",  		      						"MOD/vox/blocks/haybale.vox", 			 			{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cactus"] = {"Cactus",  			     						"MOD/vox/blocks/cactus.vox", 			     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Sugar Cane"] = {"Sugar Cane",  		      					"MOD/vox/blocks/sugarcane.vox", 		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Oak Door"] = {"Oak Door", 			      					"MOD/vox/blocks/oakdoor.vox",			      		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 32, z = 2},	{x = 16, y = 16, z = 16},	nil, 					true,  		2, "<joint size='0.2' pos='0.1 0.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.1 2.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/>"},
		["Oak Trapdoor"] = {"Oak Trapdoor", 		      				"MOD/vox/blocks/oaktrapdoor.vox",		      		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true,  		6, "<joint size='0.25' pos='0.1 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.25' pos='0.9 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/>", "<joint size='0.2' pos='0.1 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.9 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/>",},
		["Oak Fence"] = {"Oak Fence", 		      						"MOD/vox/blocks/fences/oakfence.vox",		      	{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 15, y = 16, z = 15},	nil, 					false,  	4, nil},
		["Block Of Iron"] = {"Block Of Iron", 	      					"MOD/vox/blocks/blockofiron.vox",		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block Of Gold"] = {"Block Of Gold", 	      					"MOD/vox/blocks/blockofgold.vox",		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block Of Diamond"] = {"Block Of Diamond", 	      			"MOD/vox/blocks/blockofdiamond.vox",	     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block Of Emerald"] = {"Block Of Emerald", 	      			"MOD/vox/blocks/blockofemerald.vox",	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block Of Redstone"] = {"Block Of Redstone",       			"MOD/vox/blocks/blockofredstone.vox",	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		7, "<light pos='0.8 0.9 0.8' type='sphere' color='1.00 0.00 0.00' scale='0.7' unshadowed='1.6'/>"},
		["Block Of Amethyst"] = {"Block of Amethyst",       			"MOD/vox/blocks/blockofamethyst.vox",	     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Budding Amethyst"] = {"Budding Amethyst",       				"MOD/vox/blocks/buddingamethyst.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Bookshelf"] = {"Bookshelf",  		      						"MOD/vox/blocks/bookshelf.vox",		     			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Azalea"] = {"Azalea",  		          						"MOD/vox/blocks/azalea.vox",		          		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Azalea Leaves"] = {"Azalea Leaves",  		          			"MOD/vox/blocks/azalealeaves.vox",		          	{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Big Dripleaf"] = {"Big Dripleaf",  		          			"MOD/vox/blocks/bigdripleaf.vox",		          	{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Small Dripleaf"] = {"Small Dripleaf",  		          		"MOD/vox/blocks/smalldripleaf.vox",		          	{x = 0, y = 0,  z = 0}, 	"",							{x = 19, y = 32, z = 15},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate"] = {"Deepslate",  		      						"MOD/vox/blocks/deepslate.vox",		      			{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Chiseled Deepslate"] = {"Chiseled Deepslate",  	 			"MOD/vox/blocks/chiseleddeepslate.vox",	  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Calcite"] = {"Calcite",  	 									"MOD/vox/blocks/calcite.vox",	  					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cobbled Deepslate"] = {"Cobbled Deepslate",  					"MOD/vox/blocks/cobbleddeepslate.vox",	  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Copper Block"] = {"Copper Block",  							"MOD/vox/blocks/copperblock.vox",	  				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cut Copper"] = {"Cut Copper",  								"MOD/vox/blocks/cutcopper.vox",	  					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cut Copper Stairs"] = {"Cut Copper Stairs",  					"MOD/vox/blocks/cutcopperstairs.vox",	  			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		["Exposed Copper"] = {"Exposed Copper", 						"MOD/vox/blocks/exposedcopper.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Exposed Cut Copper"] = {"Exposed Cut Copper", 				"MOD/vox/blocks/exposedcutcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},				
		["Weathered Copper Block"] = {"Weathered Copper Block", 		"MOD/vox/blocks/weatheredcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Weathered Cut Copper"] = {"Weathered Cut Copper", 			"MOD/vox/blocks/weatheredcutcopper.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		["Oxidized Copper Block"] = {"Oxidized Copper Block", 			"MOD/vox/blocks/oxidizedcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Oxidized Cut Copper"] = {"Oxidized Cut Copper", 				"MOD/vox/blocks/oxidizedcutcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		["Deepslate Bricks"] = {"Deepslate Bricks",        				"MOD/vox/blocks/deepslatebricks.vox",	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Bricks Slab"] = {"Deepslate Bricks Slab",   		"MOD/vox/blocks/deepslatebricksslab.vox",	  		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		["Deepslate Bricks Stairs"] = {"Deepslate Bricks Stairs", 		"MOD/vox/blocks/deepslatebricksstairs.vox", 		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		["Deepslate Redstone Ore"] = {"Deepslate Redstone Ore", 		"MOD/vox/blocks/deepslateredstoneore.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Coal Ore"] = {"Deepslate Coal Ore",      			"MOD/vox/blocks/deepslatecoalore.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Copper Ore"] = {"Deepslate Copper Ore",    			"MOD/vox/blocks/deepslatecopperore.vox",    		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Diamond Ore"] = {"Deepslate Diamond Ore",  			"MOD/vox/blocks/deepslatediamondore.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Emerald Ore"] = {"Deepslate Emerald Ore",   		"MOD/vox/blocks/deepslateemeraldore.vox", 			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Gold Ore"] = {"Deepslate Gold Ore",      			"MOD/vox/blocks/deepslategoldore.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Iron Ore"] = {"Deepslate Iron Ore",      			"MOD/vox/blocks/deepslateironore.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Lapis Lazuli Ore"] = {"Deepslate Lapis Lazuli Ore", "MOD/vox/blocks/deepslatelapislazuliore.vox",		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Tiles"] = {"Deepslate Tiles", 						"MOD/vox/blocks/deepslatetiles.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Deepslate Tile Stairs"] = {"Deepslate Tile Stairs", 			"MOD/vox/blocks/deepslatetilestairs.vox",			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		["Deepslate Tile Slab"] = {"Deepslate Tile Slab",       	 	"MOD/vox/blocks/deepslatetileslab.vox",        		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		["Dripstone Block"] = {"Dripstone Block", 						"MOD/vox/blocks/dripstoneblock.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Flowering Azalea"] = {"Flowering Azalea", 					"MOD/vox/blocks/floweringazalea.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Flowering Azalea Leaves"] = {"Flowering Azalea Leaves", 		"MOD/vox/blocks/floweringazalealeaves.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Frogspawn"] = {"Frogspawn", 									"MOD/vox/blocks/frogspawn.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Glow Lichen"] = {"Glow Lichen", 								"MOD/vox/blocks/glowlichen.vox",					{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 1},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='0.91 0.91 0.71' scale='0.3' unshadowed='1.25'/>"},
		["Glowing Item Frame"] = {"Glowing Item Frame", 				"MOD/vox/blocks/glowingitemframe.vox",				{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z =2},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='0.91 0.91 0.71' scale='0.3' unshadowed='1.25'/>"},
		["Hanging Roots"] = {"Hanging Roots", 							"MOD/vox/blocks/hangingroots.vox",					{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 11, z =1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Jigsaw Block"] = {"Jigsaw Block", 							"MOD/vox/blocks/jigsawblock.vox",					{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Structure Block"] = {"Structure Block", 						"MOD/vox/blocks/structureblock.vox",				{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Amethyst Cluster"] = {"Amethyst Cluster", 					"MOD/vox/blocks/amethystcluster.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 15, z = 1},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Large Amethyst Bud"] = {"Large Amethyst Bud", 				"MOD/vox/blocks/largeamethystbud.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 12, y = 10, z = 1},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Medium Amethyst Bud"] = {"Medium Amethyst Bud", 				"MOD/vox/blocks/mediumamethsytbud.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 10, y = 7, z = 1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Small Amethyst Bud"] = {"Small Amethyst Bud", 				"MOD/vox/blocks/smallamethystbud.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 10, y = 5, z = 1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		["Mangrove Door"] = {"Mangrove Door", 			      			"MOD/vox/blocks/mangrovedoor.vox",			      	{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 32, z = 2},	{x = 16, y = 16, z = 16},	nil, 					true,  		2, "<joint size='0.2' pos='0.1 0.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.1 2.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/>"},
		["Mangrove Leaves"] = {"Mangrove Leaves", 						"MOD/vox/blocks/mangroveleaves.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mangrove Log"] = {"Mangrove Log", 							"MOD/vox/blocks/mangrovelog.vox",					{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mangrove Planks"] = {"Mangrove Planks", 						"MOD/vox/blocks/mangroveplanks.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mangrove Propagule"] = {"Mangrove Propagule", 				"MOD/vox/blocks/mangrovepropagule.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 7, y = 15, z = 1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mangrove Roots"] = {"Mangrove Roots", 						"MOD/vox/blocks/mangroveroots.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mangrove Trapdoor"] = {"Mangrove Trapdoor", 					"MOD/vox/blocks/mangrovetrapdoor.vox",				{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true,  		6, "<joint size='0.25' pos='0.1 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.25' pos='0.9 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/>", "<joint size='0.2' pos='0.1 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.9 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/>",},
		["Moss Block"] = {"Moss Block", 								"MOD/vox/blocks/mossblock.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Moss Carpet"] = {"Moss Carpet", 								"MOD/vox/blocks/mosscarpet.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Stripped Mangrove Log"] = {"Stripped Mangrove Log", 			"MOD/vox/blocks/strippedmangrove.vox",				{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mud"] = {"Mud", 												"MOD/vox/blocks/mud.vox",							{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Mudbrick"] = {"Mudbrick", 									"MOD/vox/blocks/mudbricks.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Muddy Mangrove Roots"] = {"Muddy Mangrove Roots", 			"MOD/vox/blocks/muddymangroveroots.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Ochre Froglight"] = {"Ochre Froglight", 						"MOD/vox/blocks/ochrefroglight.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1," <light pos='0.8 0.9 0.8' type='sphere' color='0.91 0.91 0.71' scale='0.25' unshadowed='1.25'/>"},
		["Pearlescent Froglight"] = {"Pearlescent Froglight", 			"MOD/vox/blocks/pearlescentfroglight.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1," <light pos='0.8 0.9 0.8' type='sphere' color='0.82 0.72 0.86' scale='0.25' unshadowed='1.25'/>"},
		["Verdant Froglight"] = {"Verdant Froglight", 					"MOD/vox/blocks/verdantfroglight.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1," <light pos='0.8 0.9 0.8' type='sphere' color='0.71 0.83 0.68' scale='0.25' unshadowed='1.25'/>"},
		["Packed Mud"] = {"Packed Mud", 								"MOD/vox/blocks/packedmud.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Polished Deepslate"] = {"Polished Deepslate", 				"MOD/vox/blocks/polisheddeepslate.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block of Raw Copper"] = {"Block of Raw Copper", 				"MOD/vox/blocks/blockofrawcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block of Raw Gold"] = {"Block of Raw Gold", 					"MOD/vox/blocks/blockofrawgold.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Block of Raw Iron"] = {"Block of Raw Iron", 					"MOD/vox/blocks/blockofrawiron.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Reinforced Deepslate"] = {"Reinforced Deepslate", 			"MOD/vox/blocks/reinforceddeepslate.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Rooted Dirt"] = {"Rooted Dirt", 								"MOD/vox/blocks/rooteddirt.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Sculk"] = {"Sculk", 											"MOD/vox/blocks/sculk.vox",							{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Sculk Catalyst"] = {"Sculk Catalyst", 						"MOD/vox/blocks/sculkcatalyst.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Sculk Sensor"] = {"Sculk Sensor", 							"MOD/vox/blocks/sculksensor.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Sculk Shrieker"] = {"Sculk Shrieker", 						"MOD/vox/blocks/sculkshrieker.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 15, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Tuff"] = {"Tuff", 											"MOD/vox/blocks/tuff.vox",							{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Tinted Glass"] = {"Tinted Glass", 							"MOD/vox/blocks/tintedglass.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Redstone Dust"] = {"Redstone Dust", 							"MOD/vox/blocks/redstonedust/redstonedust.vox",		{x = 0, y = 0,  z = 0}, 	"tags='nocull'",			{x = 16, y = 1,  z = 16},	{x = 15, y = 16, z = 15},	nil, 					false, 		7, nil},
		["Redstone Repeater"] = {"Redstone Repeater", 					"MOD/vox/blocks/redstonerepeater.xml",				{x = 0, y = 1,  z = 0}, 	"tags='interact=Tick:'",	{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		7, nil},
		["Stone Button"] = {"Stone Button", 							"MOD/vox/blocks/stonebutton.xml",					{x = 1, y = 1,  z = 1}, 	"tags='interact=Interact'",	{x = 16, y = 16, z = 16},	{x = 15, y = 16, z = 16},	nil, 					false, 		7, nil},
		["Oak Button"] = {"Oak Button", 								"MOD/vox/blocks/oakbutton.xml",						{x = 1, y = 1,  z = 1}, 	"tags='interact=Interact'",	{x = 16, y = 16, z = 16},	{x = 15, y = 16, z = 16},	nil, 					false, 		7, nil},
		["Redstone Lamp"] = {"Redstone Lamp", 							"MOD/vox/blocks/redstonelamp.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		7, "<light tags='LAMPID' pos='0.8 0.8 0.8' type='sphere' color='0.71 0.83 0.68' scale='5.00' unshadowed='1.6'/>"},
		["Oak Fence Gate"] = {"Oak Fence Gate", 						"MOD/vox/blocks/oakfencegate.xml",					{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		8, nil},
		["Redstone Torch"] = {"Redstone Torch", 						"MOD/vox/blocks/redstonetorch.vox",					{x = 0, y = 0,  z = 0}, 	"tags='nocull'",			{x = 16, y = 16, z = 16},	{x = -3, y = -3, z = -3},	nil, 					false, 		7, "<light tags='LAMPID' pos='0.8 0.8 0.8' type='sphere' color='0.71 0.20 0.00' scale='0.50' unshadowed='0.01'/>"},
		["Lever"] = {"Lever", 											"MOD/vox/blocks/lever.xml",							{x = 1, y = 1,  z = 1}, 	"tags='nocull'",			{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		7, nil},
		["Ender Pearl"] = {"Ender Pearl", 								"None",												{x = 1, y = 1,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		10, nil},
		["Flint And Steel"] = {"Flint And Steel", 						"None",												{x = 1, y = 1,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		10, nil},
		["Fire Charge"] = {"Fire Charge", 								"None",												{x = 1, y = 1,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		10, nil},
		["White Wool"] = {"White Wool", 								"MOD/vox/blocks/wool/whitewool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Light Gray Wool"] = {"Light Gray Wool", 						"MOD/vox/blocks/wool/lightgraywool.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Gray Wool"] = {"Gray Wool", 									"MOD/vox/blocks/wool/graywool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Black Wool"] = {"Black Wool", 								"MOD/vox/blocks/wool/blackwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Red Wool"] = {"Red Wool", 									"MOD/vox/blocks/wool/redwool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Orange Wool"] = {"Orange Wool", 								"MOD/vox/blocks/wool/orangewool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Yellow Wool"] = {"Yellow Wool", 								"MOD/vox/blocks/wool/yellowwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Lime Wool"] = {"Lime Wool", 									"MOD/vox/blocks/wool/limewool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Green Wool"] = {"Green Wool", 								"MOD/vox/blocks/wool/greenwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Cyan Wool"] = {"Cyan Wool", 									"MOD/vox/blocks/wool/cyanwool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Light Blue Wool"] = {"Light Blue Wool", 						"MOD/vox/blocks/wool/lightbluewool.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Blue Wool"] = {"Blue Wool", 									"MOD/vox/blocks/wool/bluewool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Purple Wool"] = {"Purple Wool", 								"MOD/vox/blocks/wool/purplewool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Magenta Wool"] = {"Magenta Wool", 							"MOD/vox/blocks/wool/magentawool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Pink Wool"] = {"Pink Wool", 									"MOD/vox/blocks/wool/pinkwool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Brown Wool"] = {"Brown Wool", 								"MOD/vox/blocks/wool/brownwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["White Carpet"] = {"White Carpet", 							"MOD/vox/blocks/wool/whitewool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Light Gray Carpet"] = {"Light Gray Carpet", 					"MOD/vox/blocks/wool/lightgraywool.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Gray Carpet"] = {"Gray Carpet", 								"MOD/vox/blocks/wool/graywool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Black Carpet"] = {"Black Carpet", 							"MOD/vox/blocks/wool/blackwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Red Carpet"] = {"Red Carpet", 								"MOD/vox/blocks/wool/redwool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Orange Carpet"] = {"Orange Carpet", 							"MOD/vox/blocks/wool/orangewool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Yellow Carpet"] = {"Yellow Carpet", 							"MOD/vox/blocks/wool/yellowwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Lime Carpet"] = {"Lime Carpet", 								"MOD/vox/blocks/wool/limewool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Green Carpet"] = {"Green Carpet", 							"MOD/vox/blocks/wool/greenwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Cyan Carpet"] = {"Cyan Carpet", 								"MOD/vox/blocks/wool/cyanwool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Light Blue Carpet"] = {"Light Blue Carpet", 					"MOD/vox/blocks/wool/lightbluewool.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Blue Carpet"] = {"Blue Carpet", 								"MOD/vox/blocks/wool/bluewool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Purple Carpet"] = {"Purple Carpet", 							"MOD/vox/blocks/wool/purplewool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Magenta Carpet"] = {"Magenta Carpet", 						"MOD/vox/blocks/wool/magentawool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Pink Carpet"] = {"Pink Carpet", 								"MOD/vox/blocks/wool/pinkwool.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Brown Carpet"] = {"Brown Carpet", 							"MOD/vox/blocks/wool/brownwool.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 17, z = 16},	nil, 					false, 		1, nil},
		["Stone Pressure Plate"] = {"Stone Pressure Plate", 			"MOD/vox/blocks/stonepressureplate.xml",			{x = 0, y = 0,  z = 0}, 	"",							{x = 14, y = 1, z = 14},	{x = 16, y = 16, z = 16},	nil, 					false, 		7, nil},
		["Oak Pressure Plate"] = {"Oak Pressure Plate", 				"MOD/vox/blocks/oakpressureplate.xml",				{x = 0, y = 0,  z = 0}, 	"",							{x = 14, y = 1, z = 14},	{x = 16, y = 16, z = 16},	nil, 					false, 		7, nil},
		["Chest"] = {"Chest", 											"MOD/vox/blocks/chest.xml",							{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Obsidian"] = {"Obsidian", 									"MOD/vox/blocks/Obsidian.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["End Rod"] = {"End Rod", 										"MOD/vox/blocks/end_rod.xml",						{x = 1, y = 1,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='1.00 1.00 1.00' scale='0.7' unshadowed='1.6'/>"},
		["End Stone"] = {"End Stone", 									"MOD/vox/blocks/end_stone.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["End Stone Bricks"] = {"End Stone Bricks", 					"MOD/vox/blocks/end_stone_bricks.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Purpur Block"] = {"Purpur Block", 							"MOD/vox/blocks/purpur_block.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		["Purpur Pillar"] = {"Purpur Pillar ", 							"MOD/vox/blocks/purpur_pillar.vox",					{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		}																													--ROTATE TOWARDS PLAYER?
																															--


--[[
 This is one of those lines above but cut up to explain:

Block Name: ["Chest"] = 
Used to Identify which block it is

Block Name: {"Chest",
Mainly legacy, still in use some places.

Path To Vox/XML: "MOD/vox/blocks/chest.xml",
Path to the XML or VOX file, XML is really only needed for blocks with multiple parts such as gates, chests etc.

Axis Rotation: {x = 0, y = 1,  z = 0},
Defines which axis to rotate on
x = 0, y = 0, z = 0 for normal
x = 1, y = 0, z = 1 for logs
x = 0, y = 1, z = 0 for entities like chests, doors beds etc
x = 1, y = 1, z = 1 for special use cases like buttons on ceilings

Teardown Tags: "",
Used to give Teardown tags like for example nocull on small blocks like torches.

Block Size: {x = 16, y = 16, z = 16},
Block size on each axis. Leave 16 for full blocks.

Block Placement Offset: {x = 16, y = 16, z = 16},
Offset from center point, used for blocks that don't adhere to standard sizing.
Leave 16 for full blocks.

SpecialFeatures: nil,
Old feature that would give blocks the ability to execute code. Unused entirely.
Leave nil unless you're importing code.

Always Physical Prop: false,
True for blocks like doors which need to be a physics prop.
Otherwise false.

Block Type: 1,
Defines what type of item it is.
1 = block
2 = door
3 = slab
4 = fence
5 = stairs
6 = trapdoor
7 = redstone
8 = fencegate
9 = item

Extra XML: nil},
Used for blocks that come as vox files that need extra mapping related data like lights for torches.
]]--

blockSprites = {}

function blocksprites_init()
	for itemId, data in pairs(blocks) do
		blockSprites[itemId] = LoadSprite("MOD/sprites/blocks/" .. itemId .. ".png")
	end
end