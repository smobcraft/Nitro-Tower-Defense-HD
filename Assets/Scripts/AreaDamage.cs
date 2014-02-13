using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AreaDamage : MonoBehaviour {

	Dictionary<Collider,Health> targets = new Dictionary<Collider,Health> ();
	List<Collider> colliders = new List<Collider> ();
	public float damagePerSecond;
	public BoxCollider box;
	float cooldown;

	void Start()
	{
		damagePerSecond += GameObject.Find ("Player").GetComponent<UnitStats> ().fsDamage;
	}

	void Update()
	{
		cooldown += Time.deltaTime;
		if (cooldown >= 1)
		{
			foreach (Collider col in colliders)
			{
				try
				{
					targets[col].DealDamage(damagePerSecond);
				}
				catch
				{
					targets.Remove(col);
				}
			}
			cooldown = 0;
		}
	}

	void OnTriggerStay (Collider col)
	{
		//Debug.Log ("here");
		if (col.gameObject.tag == "Empire")
		{
			if (!targets.ContainsKey(col))
			{
				colliders.Add(col);
				targets.Add(col,col.GetComponent<Health>());
			}
		}
	}
}
