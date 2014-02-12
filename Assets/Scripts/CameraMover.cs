using UnityEngine;
using System.Collections;

public class CameraMover : MonoBehaviour {

	public float speed;
	public float moveUp;
	public float moveDown;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		Vector3 temp = new Vector3 (0, 0, Input.GetAxis ("Vertical") + moveUp - moveDown);
		if (temp.z < 0 && transform.position.z <= -42)
		{
			//Debug.Log ("dont go down more");
		}
		else if (temp.z  > 0 && transform.position.z >= 40)
		{
			//Debug.Log ("dont go up more");
		}
		else
		{
			transform.position += temp * Time.deltaTime * speed;
		}


	}
}
