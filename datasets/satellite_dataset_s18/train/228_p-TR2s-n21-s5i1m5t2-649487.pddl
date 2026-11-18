(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	infrared3 - mode
	thermograph2 - mode
	image1 - mode
	spectrograph4 - mode
	thermograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet5)
	(supports instrument2 infrared3)
	(supports instrument2 thermograph2)
	(supports instrument2 spectrograph4)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
	(supports instrument3 thermograph0)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star3)
	(supports instrument4 image1)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 GroundStation1)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet5)
)
(:goal (and
	(pointing satellite0 Star3)
	(pointing satellite2 Star3)
	(pointing satellite3 Phenomenon2)
	(have_image Phenomenon2 infrared3)
	(have_image Star3 spectrograph4)
	(have_image Planet4 infrared3)
	(have_image Planet5 thermograph0)
))

)
