(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	spectrograph6 - mode
	infrared5 - mode
	image2 - mode
	thermograph7 - mode
	spectrograph0 - mode
	image3 - mode
	thermograph8 - mode
	image4 - mode
	infrared1 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	Star16 - direction
	Star17 - direction
	Star18 - direction
	GroundStation21 - direction
	Star24 - direction
	Star27 - direction
	GroundStation28 - direction
	Star22 - direction
	Star12 - direction
	Star1 - direction
	Star19 - direction
	GroundStation25 - direction
	Star20 - direction
	Star26 - direction
	GroundStation23 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Planet31 - direction
	Planet32 - direction
)
(:init
	(supports instrument0 spectrograph6)
	(supports instrument0 image4)
	(supports instrument0 image3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 Star20)
	(calibration_target instrument0 Star22)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star24)
	(supports instrument1 thermograph8)
	(supports instrument1 thermograph7)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation25)
	(calibration_target instrument1 Star19)
	(supports instrument2 thermograph7)
	(supports instrument2 infrared1)
	(supports instrument2 infrared5)
	(calibration_target instrument2 Star20)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph7)
	(calibration_target instrument3 GroundStation23)
	(calibration_target instrument3 Star26)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation15)
)
(:goal (and
	(pointing satellite0 Star2)
	(pointing satellite1 Star22)
	(have_image Phenomenon29 infrared1)
	(have_image Phenomenon29 thermograph7)
	(have_image Planet30 image3)
	(have_image Planet30 thermograph8)
	(have_image Planet30 image4)
	(have_image Planet31 thermograph7)
	(have_image Planet31 image2)
	(have_image Planet31 image4)
	(have_image Planet32 infrared1)
))

)
