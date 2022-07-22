	
blocks = 
	{ --Block Name, 				      		Vox Path, 							      			Axis Rotation, 		  		Block Properties,			Block Size,					Offset,						specialFeatures(shape), alwaysProp, blockType (block, door, slab, fence, stairs, trapdoor), ExtraXML, AltXML}
		{"Grass", 			      				"MOD/vox/blocks/grass.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Dirt", 			    	  			"MOD/vox/blocks/dirt.vox", 			     			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Stone", 	  		      				"MOD/vox/blocks/stone.vox", 			     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cobblestone",							"MOD/vox/blocks/cobblestone.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cobblestone Stairs",      			"MOD/vox/blocks/cobblestonestairs.vox",     		{x = 0, y = 1,  z = 0},   	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		{"Mossy Cobblestone",       			"MOD/vox/blocks/mossycobble.vox", 		  			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Oak Log", 		  	    			"MOD/vox/blocks/oaklog.vox", 		          		{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Oak Leaves",   		      			"MOD/vox/blocks/oakleaves.vox", 	          		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Oak Planks", 	          				"MOD/vox/blocks/oakplanks.vox", 	          		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Oak Plank Slab",        				"MOD/vox/blocks/oakplanks.vox",   		  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		{"TNT", 				     			"MOD/vox/blocks/tnt.vox", 				  			{x = 0, y = 0,  z = 0}, 	"tags='explosive=2'", 		{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		{"Crafting Table", 	     				"MOD/vox/blocks/craftingtable.vox", 	     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		{"Smithing Table", 	      				"MOD/vox/blocks/smithingtable.vox", 	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Furnace", 			      			"MOD/vox/blocks/furnace.vox", 			  			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		{"Torch", 			      				"MOD/vox/blocks/torch.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = -3, y = -3, z = -3},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='1 0.85 0.31' size='0.25 0.25' unshadowed='0.25'/>"},
		{"Bricks", 			      				"MOD/vox/blocks/bricks.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil}, 
		{"Sand", 				      			"MOD/vox/blocks/sand.vox", 			      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true, 		1, nil},
		{"Soul Sand", 				      		"MOD/vox/blocks/soulsand.vox", 			      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Sandstone", 		     				"MOD/vox/blocks/sandstone.vox", 		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cut Sandstone", 	      				"MOD/vox/blocks/cutsandstone.vox", 	      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Chiseled Sandstone",					"MOD/vox/blocks/chiseledsandstone.vox",     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Smooth Sandstone", 	      			"MOD/vox/blocks/smoothsandstone.vox",       		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Smooth Stone", 		      			"MOD/vox/blocks/smoothstone.vox", 		  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Smooth Stone Slab",       			"MOD/vox/blocks/smoothstoneslab.vox", 	  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		{"Stone Bricks", 		      			"MOD/vox/blocks/stonebricks.vox", 		  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Stone Brick Stairs",      			"MOD/vox/blocks/stonebrickstairs.vox",      		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		{"Stone Brick Slab",       	 			"MOD/vox/blocks/stonebrickslab.vox",        		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		{"Bedrock", 			      			"MOD/vox/blocks/bedrock.vox", 			  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Basalt", 			      				"MOD/vox/blocks/basalt.vox", 			      		{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Smooth Basalt", 						"MOD/vox/blocks/smoothbasalt.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		{"Glass", 			     				"MOD/vox/blocks/glass.vox", 			      		{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Loom", 				      			"MOD/vox/blocks/loom.vox", 			      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cartography Table",       			"MOD/vox/blocks/cartographytable.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cauldron",  		      				"MOD/vox/blocks/cauldron.vox", 		      			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Hay Bale",  		      				"MOD/vox/blocks/haybale.vox", 			 			{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cactus",  			     			"MOD/vox/blocks/cactus.vox", 			     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Sugar Cane",  		      			"MOD/vox/blocks/sugarcane.vox", 		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Oak Door", 			      			"MOD/vox/blocks/oakdoor.vox",			      		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 32, z = 2},	{x = 16, y = 16, z = 16},	nil, 					true,  		2, "<joint size='0.2' pos='0.1 0.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.1 2.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/>"},
		{"Oak Trapdoor", 		      			"MOD/vox/blocks/oaktrapdoor.vox",		      		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true,  		6, "<joint size='0.25' pos='0.1 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.25' pos='0.9 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/>", "<joint size='0.2' pos='0.1 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.9 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/>",},
		{"Oak Fence", 		      				"MOD/vox/blocks/fences/oakfence.vox",		      	{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false,  	4, nil},
		{"Block Of Iron", 	      				"MOD/vox/blocks/blockofiron.vox",		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block Of Gold", 	      				"MOD/vox/blocks/blockofgold.vox",		      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block Of Diamond", 	      			"MOD/vox/blocks/blockofdiamond.vox",	     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block Of Emerald", 	      			"MOD/vox/blocks/blockofemerald.vox",	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block Of Redstone",       			"MOD/vox/blocks/blockofredstone.vox",	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='1 0.00 0.00' size='0.25 0.25' unshadowed='1.25'/>"},
		{"Block of Amethyst",       			"MOD/vox/blocks/blockofamethyst.vox",	     		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Budding Amethyst",       				"MOD/vox/blocks/buddingamethyst.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Bookshelf",  		      				"MOD/vox/blocks/bookshelf.vox",		     			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Azalea",  		          			"MOD/vox/blocks/azalea.vox",		          		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Azalea Leaves",  		          		"MOD/vox/blocks/azalealeaves.vox",		          	{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Big Dripleaf",  		          		"MOD/vox/blocks/bigdripleaf.vox",		          	{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Small Dripleaf",  		          	"MOD/vox/blocks/smalldripleaf.vox",		          	{x = 0, y = 0,  z = 0}, 	"",							{x = 19, y = 32, z = 15},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate",  		      				"MOD/vox/blocks/deepslate.vox",		      			{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Chiseled Deepslate",  	 			"MOD/vox/blocks/chiseleddeepslate.vox",	  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Calcite",  	 						"MOD/vox/blocks/calcite.vox",	  					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cobbled Deepslate",  					"MOD/vox/blocks/cobbleddeepslate.vox",	  			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Copper Block",  						"MOD/vox/blocks/copperblock.vox",	  				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cut Copper",  						"MOD/vox/blocks/cutcopper.vox",	  					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Cut Copper Stairs",  					"MOD/vox/blocks/cutcopperstairs.vox",	  			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		{"Exposed Copper", 						"MOD/vox/blocks/exposedcopper.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Exposed Cut Copper", 					"MOD/vox/blocks/exposedcutcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},				
		{"Weathered Copper Block", 				"MOD/vox/blocks/weatheredcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Weathered Cut Copper", 				"MOD/vox/blocks/weatheredcutcopper.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		{"Oxidized Copper Block", 				"MOD/vox/blocks/oxidizedcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Oxidized Cut Copper", 				"MOD/vox/blocks/oxidizedcutcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		{"Deepslate Bricks",        			"MOD/vox/blocks/deepslatebricks.vox",	      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Bricks Slab",   			"MOD/vox/blocks/deepslatebricksslab.vox",	  		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		{"Deepslate Bricks Stairs", 			"MOD/vox/blocks/deepslatebricksstairs.vox", 		{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		{"Deepslate Redstone Ore", 				"MOD/vox/blocks/deepslateredstoneore.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Coal Ore",      			"MOD/vox/blocks/deepslatecoalore.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Copper Ore",    			"MOD/vox/blocks/deepslatecopperore.vox",    		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Diamond Ore",  				"MOD/vox/blocks/deepslatediamondore.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Emerald Ore",   			"MOD/vox/blocks/deepslateemeraldore.vox", 			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Gold Ore",      			"MOD/vox/blocks/deepslategoldore.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Iron Ore",      			"MOD/vox/blocks/deepslateironore.vox",      		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Lapis Lazuli Ore", 			"MOD/vox/blocks/deepslatelapislazuliore.vox",		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Tiles", 					"MOD/vox/blocks/deepslatetiles.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Deepslate Tile Stairs", 				"MOD/vox/blocks/deepslatetilestairs.vox",			{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		5, nil},
		{"Deepslate Tile Slab",       	 		"MOD/vox/blocks/deepslatetileslab.vox",        		{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 8,  z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		3, nil},
		{"Dripstone Block", 					"MOD/vox/blocks/dripstoneblock.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Flowering Azalea", 					"MOD/vox/blocks/floweringazalea.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Flowering Azalea Leaves", 			"MOD/vox/blocks/floweringazalealeaves.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Frogspawn", 							"MOD/vox/blocks/frogspawn.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Glow Lichen", 						"MOD/vox/blocks/glowlichen.vox",					{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 1},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='0.91 0.91 0.71' size='0.25 0.25' unshadowed='1.25'/>"},
		{"Glowing Item Frame", 					"MOD/vox/blocks/glowingitemframe.vox",				{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z =2},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, "<light pos='0.8 0.9 0.8' type='sphere' color='0.91 0.91 0.71' size='0.25 0.25' unshadowed='1.25'/>"},
		{"Hanging Roots", 						"MOD/vox/blocks/hangingroots.vox",					{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 11, z =1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Jigsaw Block", 						"MOD/vox/blocks/jigsawblock.vox",					{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Structure Block", 					"MOD/vox/blocks/structureblock.vox",				{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Amethyst Cluster", 					"MOD/vox/blocks/amethystcluster.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 15, z = 1},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Large Amethyst Bud", 					"MOD/vox/blocks/largeamethystbud.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 12, y = 10, z = 1},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Medium Amethyst Bud", 				"MOD/vox/blocks/mediumamethsytbud.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 10, y = 7, z = 1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Small Amethyst Bud", 					"MOD/vox/blocks/smallamethystbud.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 10, y = 5, z = 1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},		
		{"Mangrove Door", 			      		"MOD/vox/blocks/mangrovedoor.vox",			      	{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 32, z = 2},	{x = 16, y = 16, z = 16},	nil, 					true,  		2, "<joint size='0.2' pos='0.1 0.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.1 2.25 0.1' rot='-90 0 0' limits='-90 0' type='hinge' sound='true' collide='false'/>"},
		{"Mangrove Leaves", 					"MOD/vox/blocks/mangroveleaves.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mangrove Log", 						"MOD/vox/blocks/mangrovelog.vox",					{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mangrove Planks", 					"MOD/vox/blocks/mangroveplanks.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mangrove Propagule", 					"MOD/vox/blocks/mangrovepropagule.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 7, y = 15, z = 1},		{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mangrove Roots", 						"MOD/vox/blocks/mangroveroots.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mangrove Trapdoor", 					"MOD/vox/blocks/mangrovetrapdoor.vox",				{x = 0, y = 1,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					true,  		6, "<joint size='0.25' pos='0.1 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/> <joint size='0.25' pos='0.9 0.134 0.134' rot='0 90 90' limits='-90 0' type='hinge' sound='true' collide='false'/>", "<joint size='0.2' pos='0.1 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/> <joint size='0.2' pos='0.9 0.16 0.134' rot='0 90 90' limits='0 90' type='hinge' sound='true' collide='false'/>",},
		{"Moss Block", 							"MOD/vox/blocks/mossblock.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Moss Carpet", 						"MOD/vox/blocks/mosscarpet.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 1, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Stripped Mangrove Log", 				"MOD/vox/blocks/strippedmangrove.vox",				{x = 1, y = 0,  z = 1}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mud", 								"MOD/vox/blocks/mud.vox",							{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Mudbrick", 							"MOD/vox/blocks/mudbricks.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Muddy Mangrove Roots", 				"MOD/vox/blocks/muddymangroveroots.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Ochre Froglight", 					"MOD/vox/blocks/ochrefroglight.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1," <light pos='0.8 0.9 0.8' type='sphere' color='0.91 0.91 0.71' size='0.25 0.25' unshadowed='1.25'/>"},
		{"Pearlescent Froglight", 				"MOD/vox/blocks/pearlescentfroglight.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1," <light pos='0.8 0.9 0.8' type='sphere' color='0.82 0.72 0.86' size='0.25 0.25' unshadowed='1.25'/>"},
		{"Verdant Froglight", 					"MOD/vox/blocks/verdantfroglight.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1," <light pos='0.8 0.9 0.8' type='sphere' color='0.71 0.83 0.68' size='0.25 0.25' unshadowed='1.25'/>"},
		{"Packed Mud", 							"MOD/vox/blocks/packedmud.vox",						{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Polished Deepslate", 					"MOD/vox/blocks/polisheddeepslate.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block of Raw Copper", 				"MOD/vox/blocks/blockofrawcopper.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block of Raw Gold", 					"MOD/vox/blocks/blockofrawgold.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Block of Raw Iron", 					"MOD/vox/blocks/blockofrawiron.vox",				{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Reinforced Deepslate", 				"MOD/vox/blocks/reinforceddeepslate.vox",			{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Rooted Dirt", 						"MOD/vox/blocks/rooteddirt.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Sculk", 								"MOD/vox/blocks/sculk.vox",							{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Sculk Catalyst", 						"MOD/vox/blocks/sculkcatalyst.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Sculk Sensor", 						"MOD/vox/blocks/sculksensor.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Sculk Shrieker", 						"MOD/vox/blocks/sculkshrieker.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 15, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Tuff", 								"MOD/vox/blocks/tuff.vox",							{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
		{"Tinted Glass", 						"MOD/vox/blocks/tintedglass.vox",					{x = 0, y = 0,  z = 0}, 	"",							{x = 16, y = 16, z = 16},	{x = 16, y = 16, z = 16},	nil, 					false, 		1, nil},
	}