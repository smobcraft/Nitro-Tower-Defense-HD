using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

	public float spiderSpawnRate;
	float spiderCD;
	public float venomSpitterSpawnRate;
	float venomSpitterCD;
	public GameObject spider;
	public GameObject venomSpitter;
	public GameObject spawnLoc;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		spiderCD += Time.deltaTime;
		venomSpitterCD += Time.deltaTime;
		if (spiderCD >= spiderSpawnRate)
		{
			Instantiate(spider, spawnLoc.transform.position, transform.rotation);
			spiderCD = 0;
		}
		if (venomSpitterCD >= venomSpitterSpawnRate)
		{
			Instantiate(venomSpitter, spawnLoc.transform.position, transform.rotation);
			venomSpitterCD = 0;
		}
	}
}
