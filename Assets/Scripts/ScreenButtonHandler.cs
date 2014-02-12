using UnityEngine;
using System.Collections;

public class ScreenButtonHandler : MonoBehaviour {

	public bool unitSpawnButtonIsOn;
	public GameObject spawnButtons;
	public GameObject playerBase;

	// Use this for initialization
	void Start () {
		if (tag == "Colony")
		{
			playerBase = GameObject.Find("Colony Nexus");
		}
		if (tag == "Empire")
		{
			playerBase = GameObject.Find("Empire Nexus");
		}
	}
	
	// Update is called once per frame
	void Update () {
		/*unitSpawnButtonIsOn = playerBase.GetComponent<Selectable> ().isSelected;
		if (unitSpawnButtonIsOn)
		{
			//spawnButtons.SetActive(true);
		}
		else
		{
			//spawnButtons.SetActive(false);
		}*/
	}
}
